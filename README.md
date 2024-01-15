# [Fresh manual flake install from Minimal ISO on local PC](https://github.com/nrbray/nixos-configuration/blob/main/README.md)

Oh boy!  Whilst in hindsight this is extremely simple (and easier done with the graphical installer), it was hard to find many complete examples of the manual install process to assure me I would be able to do all I wanted:

  - Start with a Flake (to avoid starting non-Flake and switching over without fully understanding how to do it from the beginning)
  - Full disk encryption
  - Suspend to disk (aka hibernate) given the encryption (a starting point without the random luks key)
  - BTRFS (used because I've adopted the very elegant snapshot, send and receive for backups)
  - UEFI (with secure boot planned for the future)

I learnt about the chicken and egg: hardware needs to be configured before it can be scanned (by nixos-generate-config) and then used in the Flake (by convention hardware-configuration.nix) to install.  Of course what I wanted was to use the definition of the hardware (in Nix) to do the configuration, https://github.com/nix-community/disko does this but I had finished this before I found it.

What I found awesome is that this command, (after installing NixOS on the target):

```nixos-rebuild switch --flake ./flake.nix#dubedary --target-host root@192.168.8.117```

Rebuilds, from the git repo, with any changed configuration **from another machine**.  Incredible. 

Before that, to install NixOS, this is what I 'made':

A Flake - https://github.com/nrbray/nixos-configuration/blob/main/flake.nix

  - I included two nixosConfigurations, to test that the one I wanted worked in the presence of another  

A Shellscript - https://github.com/nrbray/nixos-configuration/blob/main/ni

Individual steps (shellscript functions) to partition, format and mount the system SSD.  Steps A..K done on the target after booting from ISO and having network connection.

  - 0.Create_Installation_Media
  - 1.Connect_to_wifi_like_this_on_target
  - A.Find_block_device_id-link_for_nixos
  - B.Export_block_device_for_nixos
  - C.Create_partitions_uefi_swap_and_root
  - D.Full_root_disk_encryption
  - E.Format_partitions_uefi_swap_and_root
  - F.BTRFS_Subvolumes_for_root_home_srv
  - G.Mounts_for_root_home_srv_uefi
  - H.Swap_encryption
  - I.Install_git_is_an_alias
  - J.Clone_configuration_from_git
  - K.Nixos_Install_Flake
  - L.Nixos_Install_Legacy_Non_Flake_untested
  - Y.Resume_After_B_Then_G
  - Z.Go_back
  - ___publish_this_file
  - ___pull_this_file

I don't know what use this may be to others.  It might be useful as an example.  Otherwise people might help me (and others ) by pointing out where good examples are that I missed.
