{ config, pkgs, lib, ... }:

{
  imports = [ ./hardware-configuration.nix ]; # Include the results of the hardware scan.

  nix = {
    package = pkgs.nixFlakes; # https://www.breakds.org/post/flake-part-1-packaging/
    extraOptions =  "experimental-features = nix-command flakes"; # lib.optionalString (config.nix.package == pkgs.nixFlakes) https://discourse.nixos.org/t/using-experimental-nix-features-in-nixos-and-when-they-will-land-in-stable/7401/4
  };

  environment.defaultPackages = lib.mkForce [];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.initrd.secrets = { "/crypto_keyfile.bin" = null; };

  boot.initrd.luks.devices."luks-20a1f166-1f1d-4d97-99c2-a9260c817e32".device = "/dev/disk/by-uuid/20a1f166-1f1d-4d97-99c2-a9260c817e32";  # Enable swap on luks
  boot.initrd.luks.devices."luks-20a1f166-1f1d-4d97-99c2-a9260c817e32".keyFile = "/crypto_keyfile.bin";

  networking.hostName = "mintanin"; # Define your hostname.
  # networking.nameservers = [ "217.160.70.42" "2001:8d8:1801:86e7::1" "178.254.22.166" "2a00:6800:3:4bd::1" "81.169.136.222" "2a01:238:4231:5200::1" "185.181.61.24" "2a03:94e0:1804::1" ]; # https://opennameserver.org/
  networking.networkmanager.enable = false; #  You can not use networking.networkmanager with networking.wireless. Except if you mark some interfaces as <literal>unmanaged</literal> by NetworkManager.
  networking.useNetworkd = true; 
  services.resolved = {
    enable = true;
    dnssec = "false";
    domains = [ "~." ];
    extraConfig = ''
      DNSOverTLS=yes 
      DNS=8.8.8.8 1.1.1.1 2606:4700:4700::1111 1.0.0.1 2606:4700:4700::1001'';
  };
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.wireless.networks."Optus_B818_D3DA".psk = "9L24F93320B";
  networking.wireless.networks."Optus_B818_D3DA_5G".psk = "9L24F93320B";
  networking.wireless.networks."BTWholeHome-87M".psk = "aubergine0";
  networking.wireless.networks."CGC".psk = "CBSIFTBEC";
  networking.wireless.networks."Nigel's moto g(50)_6318".psk = "aubergine";
  networking.wireless.networks."A7 CC".psk = "aubergine";
  networking.wireless.networks."BT-K8CM7P".psk = "bdJknkGvrdquq4";
  networking.firewall.allowedTCPPorts = [ 143 465 587 993 8384 22000 ];  # Syncthing ports + wireguard
  networking.firewall.allowedUDPPorts = [ 22000 21027 51820 ];

  # systemd.services.NetworkManager-wait-online.enable = false; # https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;

  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "btrfs";
  # users.users.nrb.extraGroups = [ "docker" ];
  programs.nix-ld.enable = true; # https://github.com/Mic92/nix-ld

/*   networking.wireguard.interfaces = {
    wg0 = {     
      ips = [ "10.100.0.2/24" ]; # Determines the IP address and subnet of the client's end of the tunnel interface.
      listenPort = 51820; # to match firewall allowedUDPPorts (without this wg uses random port numbers)
      privateKeyFile = "/home/nrb/wireguard-keys/private"; # Path to the private key file.
      peers = [ # umask 077; mkdir ~/wireguard-keys; wg genkey > ~/wireguard-keys/private; wg pubkey < ~/wireguard-keys/private > ~/wireguard-keys/public; cat ~/wireguard-keys/public
        { 
          publicKey = "K8ZWWNRf6wFhGQ1fpewNelM5jOadRSOK9OpakmfcnV0="; 
          allowedIPs = [ "0.0.0.0/3" "32.0.0.0/4" "48.0.0.0/7" "50.0.0.0/8" "51.0.0.0/11" "51.32.0.0/14" "51.36.0.0/15" "51.38.0.0/18" "51.38.64.0/24" "51.38.65.0/27" "51.38.65.32/28" "51.38.65.48/29" "51.38.65.56/31" "51.38.65.59/32" "51.38.65.60/30" "51.38.65.64/26" "51.38.65.128/25" "51.38.66.0/23" "51.38.68.0/22" "51.38.72.0/21" "51.38.80.0/20" "51.38.96.0/19" "51.38.128.0/17" "51.39.0.0/16" "51.40.0.0/13" "51.48.0.0/12" "51.64.0.0/10" "51.128.0.0/9" "52.0.0.0/6" "56.0.0.0/5" "64.0.0.0/2" "128.0.0.0/1" ];  # https://www.procustodibus.com/blog/2021/03/wireguard-allowedips-calculator/
          endpoint = "51.38.65.58:51820"; # librespeed 01001110 me 00110011 0x33 ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577
          persistentKeepalive = 25; # Send keepalives every 25 seconds. Important to keep NAT tables alive.
        }
      ];
    };
  }; */

  # networking.useNetworkd = true;
  systemd.network = {
    enable = true;
    netdevs = {
      "50-wg0" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wg0";
          MTUBytes = "1300";
        };
        wireguardConfig = {
          PrivateKeyFile = "/etc/systemd/network/wireguard";
          ListenPort = 51820;
        };
        wireguardPeers = [
          { wireguardPeerConfig = { 
            PublicKey = "K8ZWWNRf6wFhGQ1fpewNelM5jOadRSOK9OpakmfcnV0="; 
            # AllowedIPs = [ "10.100.0.0/24" ]; # https://www.procustodibus.com/blog/2021/03/wireguard-allowedips-calculator/
            AllowedIPs = [  "0.0.0.0/3" "32.0.0.0/4" "48.0.0.0/7" "50.0.0.0/8" "51.0.0.0/9" "51.128.0.0/10" "51.192.0.0/15" "51.194.0.0/16" "51.195.0.0/17" "51.195.128.0/18" "51.195.192.0/21" "51.195.200.0/25" "51.195.200.128/28" "51.195.200.144/29" "51.195.200.152/30" "51.195.200.157/32" "51.195.200.158/31" "51.195.200.160/27" "51.195.200.192/26" "51.195.201.0/24" "51.195.202.0/23" "51.195.204.0/22" "51.195.208.0/20" "51.195.224.0/19" "51.196.0.0/14" "51.200.0.0/13" "51.208.0.0/12" "51.224.0.0/11" "52.0.0.0/6" "56.0.0.0/5" "64.0.0.0/2" "128.0.0.0/1" ];
            Endpoint = "51.195.200.156:51820";
            PersistentKeepalive = 25; # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          }; } # servmail
        # { wireguardPeerConfig = { PublicKey = "H15gzMI1Q7Au7p8tO+FKeyB08IHdB05KWaP90PXUZ1E="; AllowedIPs = [ "10.100.0.2" ]; }; } # mintanin 
        # { wireguardPeerConfig = { PublicKey = "YIfEx4ONFSjH0po3TLGQkTVrW7c4BaJP49czHzvzAUM="; AllowedIPs = [ "10.100.0.3" ]; }; } # avingate 
        # { wireguardPeerConfig = { PublicKey = "wGBgYqr9B6ieWXAV1ybMUwl11lRtk3PpM0vzYkURy3E="; AllowedIPs = [ "10.100.0.4" ]; }; } # a7cc 
        ];
      };
    };
    networks.wg0 = {
      matchConfig.Name = "wg0";
      address = ["10.100.0.2/24"];            # { publicKey = "K8ZWWNRf6wFhGQ1fpewNelM5jOadRSOK9OpakmfcnV0="; allowedIPs = [ "10.100.0.1/32" ]; } # servmail 
      DHCP = "no";
      # gateway = [ "10.100.0.1" ]; # sudo ip route add 51.195.200.156 via 192.168.8.1 dev wlp4s0; sudo ip route del default via 192.168.8.1 dev wlp4s0; sudo ip route add default via 10.100.0.1 dev wg0; ip r
      networkConfig = {
        IPv6AcceptRA = false;
      };
    };
  };

  time.timeZone = "Europe/London";  # Set your time zone.
  i18n.defaultLocale = "en_GB.UTF-8";  # Select internationalisation properties.
  console = { font = "Lat2-Terminus16"; keyMap = "uk"; };  # Configure console keymap

  services.xserver.enable = true;  # Enable the X11 windowing system.
  services.xserver.displayManager.gdm.enable = true;  # Enable the GNOME Desktop Environment.
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver = { layout = "gb"; xkbVariant = ""; };  # Configure keymap in X11
  sound.enable = true;  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    allowSFTP = false; 
    settings.challengeResponseAuthentication = false;
    extraConfig = ''
      AllowTcpForwarding yes
      X11Forwarding no
      AllowAgentForwarding no
      AllowStreamLocalForwarding no
      AuthenticationMethods publickey
    '';
  };
  
  services.openssh.settings.PermitRootLogin = "prohibit-password";
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD79k4L7xCQX+7CqrqkLs2BPfgXrcqbZfFubsk8DcuQeLiNyA+kyDDXaW88Y98CFLDO3C3EPJa/zeSM24rBCqQ7sySITzgC+gE4qqGg4LmRkR7YOQkAImtKSt5mcJxOgTGULkYKRU3s+5MIBoH7QrIMrsPUagfOOn+MZnPJ/90E0U69fRWsT3Nj+teotQsPDUJM3onbjgUfc08vbwmHdIEZD8MG5Pomn2jKId9kBtK9JEPSfu8xT7sI/aaaM0/h7Zgg1lL+JVdaNARzTUbqlIj0CNOOe8x3zVWwAwXDUGESruJiKlquTLC6AVr30seWOeIK6LExnZ/zOVe1JOciCFY3 nrb@x1t" 
  ];

  users.users.nrb = {  # Define a user account. Don't forget to set a password with ‘passwd’.
    openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC5zFqMXN4dgTzMt0LFPhl+wSxiJAUKHY9rE32dU2vri1or6CCiLdQRJUy79ovEa1bRa8p3C3F+5B+1mMssFnbotSmZ0/RSWy3sYazc4nfJkhJS50AU7T+LPWS20UNexbcEQRn6FjNsFPmKoUozToXRwbbg91IJEYyHXHnttNzBiUle5SPKYM8OF/ZZTHwgjpD82lSkh5Vek8CmYIuNeZWXYgxOBoboSjFmDLjKFVFufi2evyw18xeMtXeLNx8nPmk4WqLqX8z/S8eBK+D85LPU38+8H1WgYEVLgSuvgB5qzDq3MQR50MzC+MWvbO4Na3/XIo7RAV3XXaLJnI8Q6f9QyPlbe8Id3R2Bo8i9z9i8J3++6ZIeeDh12pOUI8Mg/mXZhiSAiIfsSxd9VLt7BlXzDn8MqWQewoh/tZVpHOsHK3onC9hovp1LAm6Q3r3ZKxTmakLLD8UdQtM8cIiHawWO2RRHQvCs7zDuUjVNd7mrpcugj/xC8kSDb25DGWhv8jE= nrb@mintanin"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCrs4NV63V7zNQlBiQrlSoioFkcy8EQX/Qsp0YqbHpj3cfL0kid4QzsEpieZJMyg/kdPhN2Cv3kPwHqd7SU4HeTl5tJYE7XFyI9+T6D+BGEUI5tV78hueDJZjOa93jd8H8RfN7xKoBSl/hOEwyEi99X/Q4OCpUcp15pDqqoC89IfBxzid6gy/072jAgMBeLUzujPFYZsybqP2Pj7FCAuwx/h51E9cbxAUtISLyxblpqj3DPh2NcRxPD5NDCKwBMVEc3nkeNTsN3FE9diw4Ebs3D3TT0nZRN+0P05NPg7bxoDcYeV6inrun/geURKKHCFrM5Htwnd8TulTuXt/gjbX/aDmMiRkKgEw9C0CPaQwwAx9H0OkfZmwr/acaTBhRtqNbiyxA1Do6gb6rldoLnXRxjww4VVKcN1EuTqpW8FNR+9HMTM4JYZW8ZldoE2lms0FH68c2QF46z6HqZGpbWLZy4Hr5g/8JCF2IzWFbjLaxTxk+jngLkrfvLYHF+9Q61IOM= nrb@redwider"
    ];
    isNormalUser = true;
    description = "Nigel Bray";
    extraGroups = [  "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
    weechat tdesktop whatsapp-for-linux 
    deltachat-desktop mutt gnome3.geary 
    vscodium lapce
    bitwarden 
    libreoffice  
    wine winetricks # rm -rf $HOME/.wine; rm -f $HOME/.config/menus/applications-merged/*wine*; rm -rf $HOME/.local/share/applications/wine; rm -f $HOME/.local/share/desktop-directories/*wine*
    ungoogled-chromium
    nushell 
    alacritty # wezterm
    # tmux
    kalker  
    ];
  };

  nixpkgs.config.allowUnfree = true;  # Allow unfree packages

  programs.gnupg.agent = { enable = true; }; # https://github.com/NixOS/nixpkgs/issues/210375 # pinentryFlavor = "gtk2"; # enableSSHSupport = true;

  services = { # https://nixos.wiki/wiki/Syncthing
    syncthing = { # https://search.nixos.org/options?channel=23.11&from=0&size=30&sort=relevance&type=packages&query=services.syncthing.settings
      enable = true;
      user = "nrb";
      # https://github.com/NixOS/nixpkgs/issues/85336#issuecomment-1287781419
      dataDir = "/home/nrb/Documents";    # Default folder for new synced folders
      configDir = "/home/nrb/.config/syncthing";   # Folder for Syncthing's settings and keys file://home/nrb/.config/syncthing/config.xml.20231208 
      guiAddress = "0.0.0.0:8384";
      overrideDevices = true;
      settings.devices = {  
        "Nigel Bray - 5T5MQUY - dellsman" = { id = "5T5MQUY-VDB67JA-SEJDHWW-TVTZ7V5-B6KXN7O-XLMSD7G-KAAR7IE-QL3GVAM"; };
        "Nigel Bray - D36E34G - mintanin" = { id = "D36E34G-HZLITDX-UHTERSJ-W2PE4ZJ-7HWLIJG-OUNY5KA-PHFNNCA-WPQ7FAN"; };
        "Nigel Bray - EPI2WFY - Hisense HNR320T" = { id = "EPI2WFY-PCWBH6P-QN3PYRX-IRBFNBI-MFSBFVR-NJTHUNO-CIVH4IS-2RCYFQR"; };
        "Nigel Bray - EZPA4DH - servmail" = { id = "EZPA4DH-7NG4U4Y-BJ2DNJH-NUHRZTU-EZVSMHL-GUG65WP-HINFLJY-5JZ3XA4"; };
        "Nigel Bray - LUB2Z3Y - gionvert" = { id = "LUB2Z3Y-GXRIX3W-GDZ7S7J-FCA4XXU-YHARCVJ-OJNRLJS-JOSNG7W-T2PUZAO"; };
        "Nigel Bray - PV3RQAM - moto g(50)" = { id = "PV3RQAM-FCX5TCL-ZSVD7RG-3Y56FMB-T2FNYWS-USPMP6B-5MJCUQ6-7IGH5QG"; };
        "Nigel Bray - SAOTSZQ - vps221852" = { id = "SAOTSZQ-MW5XXRE-YBOVKGB-XPUPAXJ-RCBMNWP-G5UWICP-HEAELXN-6I3W7QB"; };
        "Nigel Bray - TLWZV5Y - avingate" = { id = "TLWZV5Y-HDNSG76-WD4KAL7-DPNYIPZ-D2C3JLR-FZND3FD-TGQ7KQU-HAUG6QJ"; };
        "Nigel Bray - Z7QLQCQ - redwider" = { id = "Z7QLQCQ-ZGNJCIW-42D57PP-MFPDXLN-7VLZXME-AFI37SE-IBVGHIK-7UVQCAC"; };
      };
      overrideFolders = true;
      settings.folders = {
        "LK8000" = { path = "/home/nrb/dir/sync/LK8000";  devices = [ "Nigel Bray - D36E34G - mintanin" "Nigel Bray - TLWZV5Y - avingate" "Nigel Bray - Z7QLQCQ - redwider" "Nigel Bray - EPI2WFY - Hisense HNR320T" "Nigel Bray - SAOTSZQ - vps221852" "Nigel Bray - EZPA4DH - servmail" ]; };  #ID = "amsl.consulting"; 
        "itow.uk" = { path = "/home/nrb/dir/sync/itow.uk";  devices = [ "Nigel Bray - D36E34G - mintanin" "Nigel Bray - TLWZV5Y - avingate" "Nigel Bray - Z7QLQCQ - redwider" "Nigel Bray - SAOTSZQ - vps221852" "Nigel Bray - EZPA4DH - servmail" ]; };  #ID = "itow.uk"; 
        "sm-a217f_gsa5-photos" = { path = "/home/nrb/dir/sync/sm-a217f_gsa5-photos";  devices = [ "Nigel Bray - D36E34G - mintanin" "Nigel Bray - TLWZV5Y - avingate" "Nigel Bray - Z7QLQCQ - redwider" "Nigel Bray - EPI2WFY - Hisense HNR320T" "Nigel Bray - SAOTSZQ - vps221852" "Nigel Bray - EZPA4DH - servmail" ]; };  #ID = "amsl.consulting"; 
        "amsl.consulting" = { path = "/home/nrb/dir/sync/amsl.consulting";  devices = [ "Nigel Bray - D36E34G - mintanin" "Nigel Bray - TLWZV5Y - avingate" "Nigel Bray - Z7QLQCQ - redwider" "Nigel Bray - EPI2WFY - Hisense HNR320T" "Nigel Bray - SAOTSZQ - vps221852" "Nigel Bray - EZPA4DH - servmail" ]; };  #ID = "amsl.consulting"; 
        "AMSLAccounts.git" = { path = "/home/nrb/dir/sync/AMSLAccounts.git";  devices = [ "Nigel Bray - D36E34G - mintanin" "Nigel Bray - TLWZV5Y - avingate" "Nigel Bray - EPI2WFY - Hisense HNR320T" "Nigel Bray - Z7QLQCQ - redwider" "Nigel Bray - SAOTSZQ - vps221852" "Nigel Bray - EZPA4DH - servmail" ]; };  #ID = "AMSLAccounts.git"; 
        "Apk" = { path = "/home/nrb/dir/sync/Apk";  devices = [ "Nigel Bray - D36E34G - mintanin" "Nigel Bray - TLWZV5Y - avingate" "Nigel Bray - Z7QLQCQ - redwider" "Nigel Bray - EPI2WFY - Hisense HNR320T" "Nigel Bray - PV3RQAM - moto g(50)" "Nigel Bray - SAOTSZQ - vps221852" "Nigel Bray - EZPA4DH - servmail" ]; };  #ID = "Apk"; 
        "barotow.uk" = { path = "/home/nrb/dir/sync/barotow.uk";  devices = [ "Nigel Bray - D36E34G - mintanin" "Nigel Bray - TLWZV5Y - avingate" "Nigel Bray - Z7QLQCQ - redwider" "Nigel Bray - EPI2WFY - Hisense HNR320T" "Nigel Bray - SAOTSZQ - vps221852" "Nigel Bray - EZPA4DH - servmail" ]; };  #ID = "barotow.uk"; 
        "cy3zz-tnayq" = { path = "/home/nrb/dir/sync/cy3zz-tnayq";  devices = [ "Nigel Bray - D36E34G - mintanin" "Nigel Bray - TLWZV5Y - avingate" "Nigel Bray - Z7QLQCQ - redwider" "Nigel Bray - EPI2WFY - Hisense HNR320T" "Nigel Bray - PV3RQAM - moto g(50)" "Nigel Bray - SAOTSZQ - vps221852" "Nigel Bray - EZPA4DH - servmail" ]; };  #ID = "Nigel Bray - personal, private, confidential"; 
        "highvizphotography.co.uk" = { path = "/home/nrb/dir/sync/highvizphotography.co.uk";  devices = [  "Nigel Bray - D36E34G - mintanin" "Nigel Bray - TLWZV5Y - avingate" "Nigel Bray - Z7QLQCQ - redwider"  "Nigel Bray - EZPA4DH - servmail" ]; };  #ID = "highvizphotography.co.uk"; 
        "hnr320t_f1tu-photos" = { path = "/home/nrb/dir/sync/hnr320t_f1tu-photos";  devices = [ "Nigel Bray - D36E34G - mintanin" "Nigel Bray - TLWZV5Y - avingate" "Nigel Bray - EPI2WFY - Hisense HNR320T" "Nigel Bray - Z7QLQCQ - redwider" "Nigel Bray - SAOTSZQ - vps221852" "Nigel Bray - EZPA4DH - servmail" ]; };  #ID = "hnr320t_f1tu-photos"; # Hisense  
        "html" = { path = "/home/nrb/dir/sync/html";  devices = [ "Nigel Bray - D36E34G - mintanin" "Nigel Bray - TLWZV5Y - avingate" "Nigel Bray - Z7QLQCQ - redwider" "Nigel Bray - EPI2WFY - Hisense HNR320T" "Nigel Bray - SAOTSZQ - vps221852" "Nigel Bray - EZPA4DH - servmail" ]; };  #ID = "html"; 
        "jnpwu-kakym" = { path = "/home/nrb/dir/sync/jnpwu-kakym";  devices = [ "Nigel Bray - D36E34G - mintanin" "Nigel Bray - TLWZV5Y - avingate" "Nigel Bray - Z7QLQCQ - redwider" "Nigel Bray - SAOTSZQ - vps221852" "Nigel Bray - EZPA4DH - servmail" ]; };  #ID = "bin"; 
        "k6jue-oew75" = { path = "/home/nrb/dir/sync/k6jue-oew75";  devices = [ "Nigel Bray - D36E34G - mintanin" "Nigel Bray - TLWZV5Y - avingate" "Nigel Bray - Z7QLQCQ - redwider" ]; };  #ID = "www.bigfatrepack.org"; 
        "m3fzc-nkgcb" = { path = "/home/nrb/dir/sync/m3fzc-nkgcb";  devices = [ "Nigel Bray - D36E34G - mintanin" "Nigel Bray - TLWZV5Y - avingate" "Nigel Bray - Z7QLQCQ - redwider" "Nigel Bray - EPI2WFY - Hisense HNR320T" "Nigel Bray - SAOTSZQ - vps221852" "Nigel Bray - EZPA4DH - servmail" ]; };  #ID = "m3fzc-nkgcb"; # Aeroplaying.UK
        "moto_g50_g81r-photos" = { path = "/home/nrb/dir/sync/moto_g50_g81r-photos";  devices = [ "Nigel Bray - D36E34G - mintanin" "Nigel Bray - TLWZV5Y - avingate" "Nigel Bray - PV3RQAM - moto g(50)" "Nigel Bray - Z7QLQCQ - redwider" "Nigel Bray - SAOTSZQ - vps221852" "Nigel Bray - EZPA4DH - servmail" ]; };  #ID = "moto_g50_g81r-photos"; 
        "Personal_affairs_in_order" = { path = "/home/nrb/dir/sync/Personal_affairs_in_order";  devices = [ "Nigel Bray - D36E34G - mintanin" "Nigel Bray - TLWZV5Y - avingate" "Nigel Bray - Z7QLQCQ - redwider" "Nigel Bray - EPI2WFY - Hisense HNR320T" "Nigel Bray - SAOTSZQ - vps221852" "Nigel Bray - EZPA4DH - servmail" ]; };  #ID = "Personal_affairs_in_order"; 
        "to1.uk" = { path = "/home/nrb/dir/sync/to1.uk";  devices = [ "Nigel Bray - D36E34G - mintanin" "Nigel Bray - TLWZV5Y - avingate" "Nigel Bray - Z7QLQCQ - redwider" "Nigel Bray - SAOTSZQ - vps221852" "Nigel Bray - EZPA4DH - servmail" ]; };  #ID = "to1.uk"; 
        "whaerotow" = { path = "/home/nrb/dir/sync/whaerotow";  devices = [ "Nigel Bray - D36E34G - mintanin" "Nigel Bray - TLWZV5Y - avingate" "Nigel Bray - Z7QLQCQ - redwider" ]; };  #ID = "whaerotow"; 
        "org.xcsoar" = { path = "/home/nrb/dir/sync/org.xcsoar";  devices = [ "Nigel Bray - D36E34G - mintanin" "Nigel Bray - TLWZV5Y - avingate" "Nigel Bray - Z7QLQCQ - redwider" "Nigel Bray - EPI2WFY - Hisense HNR320T" "Nigel Bray - PV3RQAM - moto g(50)" "Nigel Bray - SAOTSZQ - vps221852" "Nigel Bray - EZPA4DH - servmail" ]; };  #ID = "org.xcsoar"; 
        "XCSoarDatanrb" = { path = "/home/nrb/dir/sync/XCSoarDatanrb";  devices = [ "Nigel Bray - D36E34G - mintanin" "Nigel Bray - TLWZV5Y - avingate" "Nigel Bray - Z7QLQCQ - redwider" "Nigel Bray - EPI2WFY - Hisense HNR320T" "Nigel Bray - PV3RQAM - moto g(50)" "Nigel Bray - SAOTSZQ - vps221852" "Nigel Bray - EZPA4DH - servmail" ]; };  #ID = "XCSoarDatanrb"; 
      };
    };
  };

  environment.systemPackages = with pkgs; [ rage rsync git ripgrep jq wget tmux bind host traceroute nmap ethtool pass wireguard-tools
    nixfmt nixpkgs-fmt rnix-lsp bitwarden-cli distrobox steam-run nix-index nix-alien ]; # https://github.com/NixOS/nixpkgs/issues/271722 
  
  system.stateVersion = "22.11"; # Did you read the comment?
}
