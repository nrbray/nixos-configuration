#!/usr/bin/env bash
# . <(curl -sS https://to1.uk/ni); # For more information go to: https://to1.uk/ni

# What's this?  A simple way of collecting cli tools, at any connected box with bash.

A.Find_block_device_id-link_for_nixos () { # | ssh x0.at
  alias lsblk="lsblk -o size,fstype,name,uuid,mountpoint,id-link"; lsblk # Table of information about block devices
  sudo wipefs --no-act /dev//disk/by-id/* # Display signatures for all devices
}

B.Export_block_device_for_nixos () { # Has 1 parameter, the 'id-link' from lsblk, /dev/disk/by-id link name.
  export block_device_for_nixos="$1"; # export block_device_for_nixos="/dev/disk/by-id/${1##*/}" has less informative error checking  
  if ! [ "${block_device_for_nixos%/*}" = "/dev/disk/by-id" ]; then echo "Error: \"${block_device_for_nixos}\" should start with /dev/disk/by-id/"
  elif [ -b ${block_device_for_nixos} ]; then echo "NixOS block device is \"${block_device_for_nixos}\"" 
  else echo "Error: Parameter 1 must be a block device.  \"${block_device_for_nixos}\" is not."; fi
  echo "Next step: C.. for a full run.  Y.. to resume from a previous setup"
}

C.Create_partitions_uefi_swap_and_root () {
  set -x
  export boot_efi_size="+500M" # -part1
  export swap_size="+16600M" # -part2
  export otheros_size="+20G" # -part3
  export nixos_root_size="0" # -part4
  sudo wipefs ${block_device_for_nixos} --all --backup # https://github.com/tldr-pages/tldr/blob/master/pages/linux/wipefs.md
  sudo sgdisk ${block_device_for_nixos} --clear --mbrtogpt # use of mbrtogpt option is required on MBR or BSD disks to save changes 
  sudo sgdisk ${block_device_for_nixos} --clear # in case gpt already 
  sudo sgdisk ${block_device_for_nixos} -n0:0:${boot_efi_size} -t0:ef00; sudo partprobe; export uefi_partition="-part1" # /boot/efi https://en.wikipedia.org/wiki/EFI_system_partition
  sudo sgdisk ${block_device_for_nixos} -n0:0:${swap_size} -t0:8200; sudo partprobe; export swap_partition="-part2" # Fixme: Change from 8200 if encrypted?
  sudo sgdisk ${block_device_for_nixos} -n0:0:${otheros_size} -t0:8300; sudo partprobe; export otheros_partition="-part3" # Other OS  
  sudo sgdisk ${block_device_for_nixos} -n0:0:${nixos_root_size} -t0:8300; sudo partprobe; export nixos_partition="-part4" # System root and file systems  
  export uefi_part=${block_device_for_nixos}${uefi_partition}
  export swap_part=${block_device_for_nixos}${swap_partition}
  export root_part=${block_device_for_nixos}${nixos_partition}
  set +x
}

D.Full_root_disk_encryption () {
  sudo cryptsetup luksFormat --type luks2 ${root_part} # Systemd boot, GRUB 2.12rc1 has limited support for LUKS2
  root_luks_uuid=$(sudo cryptsetup luksUUID ${root_part})
  sudo cryptsetup luksOpen ${root_part} ${root_luks_uuid}
  export root_part_luks="/dev/mapper/${root_luks_uuid}"
}

E.Format_partitions_uefi_swap_and_root () {
  sudo mkfs.fat -F32 ${uefi_part}
  sudo mkfs.btrfs -L "ni_$(date "+%Y%m%d")" ${root_part_luks}    # Format the crypted partition
  export root_btrfs_uuid=$(sudo btrfs filesystem show ${root_part_luks}  | grep uuid | awk '{print $4}') # sensitive to number of spaces in volume label  
  export root_part_luks_btrfs="/dev/disk/by-uuid/${root_btrfs_uuid}"
}

F.BTRFS_Subvolumes_for_root_home_srv () {
  set -x; export nixos_mounts="/mnt/nixos_root"
  [ -d "${nixos_mounts}" ] || sudo mkdir -p ${nixos_mounts} ; sudo mount -t btrfs -o noatime,nodiratime,compress=zstd,space_cache=v2,autodefrag ${root_part_luks_btrfs} ${nixos_mounts} # subvolumes from this master  
  [ -d "${nixos_mounts}/@root" ] || sudo btrfs subvolume create ${nixos_mounts}/@root # kernel parameter rootflags=@root=/path/to/subvolume
  [ -d "${nixos_mounts}/@home" ] || sudo btrfs subvolume create ${nixos_mounts}/@home
  [ -d "${nixos_mounts}/@srv" ] || sudo btrfs subvolume create ${nixos_mounts}/@srv
  set +x
}

G.Mounts_for_root_home_srv_uefi () {
  sudo umount ${nixos_mounts}/{home,srv,boot,}
  sudo mount -o subvol=@root,noatime,nodiratime,compress=zstd,space_cache=v2,autodefrag ${root_part_luks_btrfs} ${nixos_mounts} # / /etc /usr /var
  sudo mkdir -p ${nixos_mounts}/{home,srv,boot} # remaining mount points 
  sudo mount -o subvol=@home,compress=zstd,space_cache=v2,autodefrag ${root_part_luks_btrfs} ${nixos_mounts}/home # /home
  sudo mount -o subvol=@srv,noatime,nodiratime,compress=zstd,space_cache=v2,autodefrag ${root_part_luks_btrfs} ${nixos_mounts}/srv # /srv
  sudo mount ${uefi_part} ${nixos_mounts}/boot # /boot
  # sudo swapon ${swap_part} # Fixme: make encrypted compatible with hibernate
  echo "Next step: H.. for a full run. I.. to resume from a previous setup"
}

H.Swap_encryption () { # https://unix.stackexchange.com/questions/529047/is-there-a-way-to-have-hibernate-and-encrypted-swap-on-nixos
  swap_keyfile=${nixos_mounts}/crypto_keyfile.bin
  sudo dd count=1 bs=512 if=/dev/urandom of=${swap_keyfile} 
  sudo cryptsetup luksFormat --type luks2 ${swap_part} ${swap_keyfile} 
  sudo cryptsetup luksAddKey --key-file ${swap_keyfile} ${swap_part} # luks device with the same password as main 
  swap_luks_uuid=$(sudo cryptsetup luksUUID ${swap_part})
  sudo cryptsetup luksOpen ${swap_part} ${swap_luks_uuid}--key-file ${swap_keyfile} 
  sudo mkswap -L swap /dev/mapper/${swap_luks_uuid} # works with //dev/mapper not /dev/disk/by-uuid/...
  sudo swapon /dev/mapper/${swap_luks_uuid} # works with //dev/mapper not /dev/disk/by-uuid/...
  sudo cryptsetup config ${swap_part} --label luksswap  
  swap_part_luks="/dev/disk/by-uuid/${swap_luks_uuid}" 
}

I.Install_git_is_an_alias () { 
  echo "run the alias I.Install_git" 
}
alias I.Install_git="echo \". <(curl -sS https://to1.uk/ni) # we're now in a sub-shell so pull the scripts in with this incantation\"; nix  --extra-experimental-features nix-command --extra-experimental-features flakes shell nixpkgs#git"

J.Clone_configuration_from_git () {
  git clone https://github.com/nrbray/nixos-configuration.git 
  cd nixos-configuration
}

K.Nixos_Install_Flake () {
  set -x  
  [ -z "${block_device_for_nixos}" ] && echo "B... needed" && return 1;
  [ -z "${root_part_luks_btrfs}" ] && echo "Y... needed" && return 1;
  if sudo grep -qs 'subvol=/@root' /proc/mounts; then :; else echo "G... needed"; return 1; fi
  [ -z "$1" ] && echo "Missing parameter : value for nixos-generate-config --dir \$1" && return 1  
  dirselect=${1%/} # removes trailing slash
  if [ -e "${nixos_mounts}" ] && [ -e "${dirselect}" ] ; then 
    sudo nixos-generate-config --root ${nixos_mounts} --dir ${dirselect}
    echo Continue?; read; sudo nixos-install --verbose --root ${nixos_mounts} --flake .#${dirselect##*/}
    echo reboot
  fi
  set +x
} # Results of K... below

# ⚠️ Mount point '/boot' which backs the random seed file is world accessible, which is a security hole! ⚠️
# ⚠️ Random seed file '/boot/loader/.#bootctlrandom-seed3e7c2c395d993021' is world accessible, which is a security hole! ⚠️
# Random seed file /boot/loader/random-seed successfully written (32 bytes).

# [nixos@nixos:~/nixos-configuration]$ df -h
# Filesystem      Size  Used Avail Use% Mounted on
# /dev/dm-0       202G  1.9G  199G   1% /mnt/nixos_root
# /dev/dm-0       202G  1.9G  199G   1% /mnt/nixos_root/home
# /dev/dm-0       202G  1.9G  199G   1% /mnt/nixos_root/srv
# /dev/nvme0n1p1  500M   29M  471M   6% /mnt/nixos_root/boot

L.Nixos_Install_Legacy_Non_Flake_untested () {
  set -x  
  dirselect=${1%/} # removes trailing slash
  if [ -e "${nixos_mounts}" ] && [ -e "${dirselect}" ] ; then 
    sudo mkdir -p ${nixos_mounts}/etc/nixos
    sudo nixos-generate-config --root ${nixos_mounts} --dir ${nixos_mounts}/etc/nixos
    cp ${nixos_mounts}/etc/nixos/* .
    echo Continue?; read; sudo nixos-install --verbose --root ${nixos_mounts} 
    echo reboot
  fi
  set +x
}

Y.Resume_After_B_Then_G () {
  if [ ! -b "${block_device_for_nixos}" ] || [ -z "${block_device_for_nixos}" ]; then echo "Error: Parameter 1 must be a block device.  \"${block_device_for_nixos}\" is not."; return 1; fi
  export uefi_partition="-part1" # /boot/efi https://en.wikipedia.org/wiki/EFI_system_partition
  export swap_partition="-part2" # Fixme: Change from 8200 if encrypted?
  export otheros_partition="-part3" # Other OS  
  export nixos_partition="-part4" # System root and file systems  
  export uefi_part=${block_device_for_nixos}${uefi_partition}
  export swap_part=${block_device_for_nixos}${swap_partition}
  export root_part=${block_device_for_nixos}${nixos_partition}
  root_luks_uuid=$(sudo cryptsetup luksUUID ${root_part})
  sudo cryptsetup luksOpen ${root_part} ${root_luks_uuid}
  export root_part_luks="/dev/mapper/${root_luks_uuid}"
  export root_btrfs_uuid=$(sudo btrfs filesystem show ${root_part_luks}  | grep uuid | awk '{print $4}') # sensitive to number of spaces in volume label  
  export root_part_luks_btrfs="/dev/disk/by-uuid/${root_btrfs_uuid}"
  export nixos_mounts="/mnt/nixos_root"
  swap_luks_uuid=$(sudo cryptsetup luksUUID ${swap_part})
  sudo cryptsetup luksOpen ${swap_part} ${swap_luks_uuid} 
  sudo swapon /dev/mapper/${swap_luks_uuid} # works with //dev/mapper not /dev/disk/by-uuid/...
  echo "Next step: G.. to mount the drives"
}

Z.Go_back () {
  set -x; 
  [ -e "${nixos_mounts}" ] && sudo umount ${nixos_mounts}/{home,srv,boot/EFI,/}
  [ -e "${swap_luks_uuid}" ] && sudo cryptsetup close ${swap_luks_uuid}
  [ -e "${root_luks_uuid}" ] && sudo cryptsetup close ${root_luks_uuid}
  set +x
}

0.Create_Installation_Media () { # "$1" = "/dev/disk/by-id/${link-id_of_your_USB_stick}"  
  if ! [ "${1%/*}" = "/dev/disk/by-id" ]; then echo "Error: Expected parameter 1 \"${1}\" to be like /dev/disk/by-id/\$\{link-id_of_your_USB_stick\}"
  elif [ -b ${1} ]; then 
    echo "Installation media is \"${1}\"" 
    curl --location --continue-at - --remote-name https://channels.nixos.org/nixos-23.11/latest-nixos-minimal-x86_64-linux.iso
    echo "Press return to continue."; read; sudo dd if=latest-nixos-minimal-x86_64-linux.iso of="$1" bs=4M conv=fsync
  else echo "Error: Parameter 1 must be a block device.  \"${1}\" is not."; fi
}

1.Connect_to_wifi_like_this_on_target () { # https://github.com/erictossell/nixflakes/blob/main/docs/minimal-install.md#wireless-networking
  set -x; [ -z "${1}" ] && echo "Usage: $0 \"local-wifi-or-hostspot-ssid\" \"pre-shared-key\"  " || (
    sudo systemctl start wpa_supplicant
    sudo systemctl status wpa_supplicant # I think a variation on below worked, escaping or replacing the quotes
    wpa_cli <<wpa_cli
add_network 0
set_network 0 ssid "BTWholeHome-87M"
set_network 0 psk "aubergine0"
set_network 0 key_mgmt WPA-PSK
enable_network 0
wpa_cli
  ); set +x # https://dev.to/rpalo/bash-brackets-quick-reference-4eh6
}

___pull_this_file () {
  pull_this_file 
}
pull_this_file () {
  . <(curl -sS https://to1.uk/ni)
}

___publish_this_file () {
  publish_this_file 
}
publish_this_file () { 
  rsync -KLrcvz --info=progress2 ./ni root@to1.uk:/var/www/to1.uk/public/ni; ssh root@to1.uk -- chown -R nginx:nginx /var/www/*
}

ni-cat () { curl -sS https://to1.uk/ni; }
ni-less () { curl -sS https://to1.uk/ni | less; }
ni-sha256sum () { curl -sS https://to1.uk/ni | sha256sum; }
ni-auth () { ssh-keygen; echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDqsazlhOhBl2bmUbvnsLLYeuLBfVrLsfOt5nv3FKw9Nui1y7PmiTacU+CEDex3gLAA6KLP8a+o4uPH1y16L/ZJhADqc6cuYcnFIyMWgsO2TfFz5SUmsgSFN3FUZuJ1aMdp+hz0o2pUZIwKVAy/LwvPzvWmTlcgyQOBMWKqD/lm+KKSAV87OcnRhdhDj2/36QxDVI+5dG5yQJ0xR7mcmUxADEtrkH1ONM7a4M+or9T7285+zlXwsxkGDTKHCULHx0gfaUP5Xph4WfHFcmbKWZ+RygUWYHC/I8xHfvP4EFvPIZfv8jppysDx9sLpMsUiLylbkJ298L+Grq/H6QYc/QZG6LDF0dzqgxpAzKWjOeYBiUZ2HQ9nHNDZiWsQb6+Ai8MnRC0irPXFvYkMooNj+9JEZ5LXnm7WA4/Z99wz0Ucd3cYTazpB+H+BkK07wdecsXIC0C/bTsVo4wUSGkrezRv6Im6Mxp4Ag90FDaW3d0OmOQhiXaMsoa1p3LhT+F1zY+c= nrb@nixos' >> ~/.ssh/authorized_keys; }
ni-curl () { . <(curl -sS https://to1.uk/ni); }
alias ni-tmux="nix --extra-experimental-features nix-command --extra-experimental-features flakes shell nixpkgs#tmux"
gitlog () { git  log --pretty=format:'%C(auto)%h%C(blue) %as%C(auto) %s' --color | head -20; }
pretty_changes () { git log --graph --name-only --pretty=format:'%C(dim yellow)%ad%Creset %C(magenta)%d %Creset%C(blue)%f %Cgreen(%cr) %C(cyan)- %an%Creset' --date=short . | rg "$2" | head `[ -z "$1" ] && echo "-20" || echo $1 ` ; } # # column -ts'|' | less -r
changesafoot () { pretty_changes $1 $2 | aha >/tmp/changesafoot.html; chromium --incognito /tmp/changesafoot.html; }
git_init_on_avingate () { $(which ssh) nrb@10.100.0.3 -- "git init --initial-branch=main --bare /srv/local/git/$(git rev-list --parents HEAD | tail -1)_${PWD##*/}.git" ; }
init_main_on_avingate () { $(which ssh) nrb@10.100.0.3 -- "cd /srv/local/git/$(git rev-list --parents HEAD | tail -1)_${PWD##*/}.git; git symbolic-ref HEAD refs/heads/main" ; }
git_add_origin_on_avingate () { git remote add origin nrb@10.100.0.3:/srv/local/git/$(git rev-list --parents HEAD | tail -1)_${PWD##*/}.git; }
old_push_to_avingate () { git push -u ssh://nrb@10.100.0.3:/srv/local/git/$(git rev-list --parents HEAD | tail -1)_${PWD##*/}.git main; }
git_log_on_avingate () { $(which ssh) nrb@10.100.0.3 -- "git --git-dir=/srv/local/git/$(git rev-list --parents HEAD | tail -1)_${PWD##*/}.git  log --pretty=format:'%C(auto)%h%C(blue) %as%C(auto) %s' --color | head -20" ; }
git_match_on_avingate () { ssh nrb@10.100.0.3 "ls -ld /srv/local/git/`git rev-list --parents HEAD | tail -1`*.*"; }
alias ll='ls -lSFhar' # https://unix.stackexchange.com/questions/30925/in-bash-when-to-alias-when-to-script-and-when-to-write-a-function
alias ls='ls --color=tty -Ftr' # https://www.mankier.com/1/ls https://github.com/tldr-pages/tldr/blob/master/pages/common/ls.md
alias lsblk='lsblk -l -t -o PKNAME,KNAME,MODEL,SERIAL,UUID,SIZE,FSTYPE,MOUNTPOINT,PARTLABEL,PARTUUID'

declare -F | head -n 18

git_log_on_avingate () { $(which ssh) nrb@10.100.0.3 -- "git --git-dir=/srv/local/git/$(git rev-list --parents HEAD | tail -1)_${PWD##*/}.git  log --pretty=format:'%C(auto)%h%C(blue) %as%C(auto) %s' --color | head -20" ; }

push_to_avingate () { git push -u ssh://git@10.100.0.3:/srv/local/git/$(git rev-list --parents HEAD | tail -1)_${PWD##*/}.git main; }
pull_from_avingate () { git pull ssh://git@10.100.0.3:/srv/local/git/$(git rev-list --parents HEAD | tail -1)_${PWD##*/}.git main; }
git_init_on-greatbar () { ssh root@10.100.0.1 -- "git init --initial-branch=main --bare /srv/local/git/$(git rev-list --parents HEAD | tail -1)_${PWD##*/}.git; chown -R git:git /srv/local/git/*"; }
nixos_avingate_clone () { git clone ssh://git@10.100.0.3:/srv/local/git/70cebcd0b55ea072df629936f86059abde373b38_nixos-configuration.git /home/nrb/nixos-configuration; }

incredible-dubedary () { [ -z "$(git status --porcelain)" ] && (git push; nixos-rebuild switch --flake .#dubedary --target-host root@192.168.8.117;); }
incredible-greatbar () { [ -z "$(git status --porcelain)" ] && (git push; ssh root@51.195.200.156 -- "cd nixos-configuration/; git pull; nixos-rebuild switch --flake .#greatbar";); } 
incredible-mailhost () { [ -z "$(git status --porcelain)" ] && (git push; ssh root@to1.uk -- "cd nixos-configuration/; git pull; nixos-rebuild switch --flake .#mailhost";); } 
incredible-mailhost-old () { [ -z "$(git status --porcelain)" ] && (git push; ssh root@to1.uk -- "cd nixos-configuration/; git pull; nixos-rebuild switch --flake .#mailhost-old";); } 
incredible-avingate () { [ -z "$(git status --porcelain)" ] && (git push; nixos-rebuild switch --flake .#avingate --target-host root@192.168.8.103;); }
incredible-mintanin () { [ -z "$(git status --porcelain)" ] && (git push; sudo nixos-rebuild switch --flake .#mintanin ; echo "--target-host root@10.100.0.2";); }

git_chown_on_avingate () { 
  ssh root@10.100.0.3 -- "chown git:git /srv/local/git/$(git rev-list --parents HEAD | tail -1)_${PWD##*/}.git" ; 
  git remote set-url origin ssh://git@192.168.8.103:/srv/local/git/$(git rev-list --parents HEAD | tail -1)_${PWD##*/}.git
  git remote set-url --add --push origin ssh://git@192.168.8.103:/srv/local/git/$(git rev-list --parents HEAD | tail -1)_${PWD##*/}.git
  git remote set-url --delete --push origin ssh://nrb@192.168.8.103:/srv/local/git/$(git rev-list --parents HEAD | tail -1)_${PWD##*/}.git
  git remote set-url --delete --push origin ssh://nrb@10.100.0.3:/srv/local/git/$(git rev-list --parents HEAD | tail -1)_${PWD##*/}.git
};

incredible-pattern () { # . ni; incredible-pattern avingate 192.168.8.103 --force [--init]
  if [ "${3}" != "--force" ]; then  [ -z "$(git status --porcelain)" ] || return 1; fi # throw git 
  if [ "${3}" = "--init" ]; then ssh root@192.168.8.103 -- "git clone /srv/local/git/$(git rev-list --parents HEAD | tail -1)_${PWD##*/}.git ${PWD##*/}"; return 1; fi
  git push;
  ssh root@"${2}" --  "cd ~/${PWD##*/}; pwd; git pull && nixos-rebuild switch --flake .#${1}";   
};
# . ni; incredible-pattern dubedary 192.168.8.117 --force 

