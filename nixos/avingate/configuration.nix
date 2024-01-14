# scp /home/nrb/dir/work/Infra/NixOS/avingate/configuration.nix root@192.168.8.103:/etc/nixos/configuration.nix; git add /home/nrb/dir/work/Infra/NixOS/avingate/configuration.nix; `which ssh` root@192.168.8.103 -- nixos-rebuild switch;

# wlp2s0: link/ether 20:7c:8f:96:d5:f7  inet 192.168.8.103/24

{ config, pkgs, lib, ... }: {
  imports = [
    ./hardware-configuration.nix
  ]; # Include the results of the hardware scan.

  nix = {
    package =
      pkgs.nixFlakes; # https://www.breakds.org/post/flake-part-1-packaging/
    extraOptions =
      "experimental-features = nix-command flakes"; # lib.optionalString (config.nix.package == pkgs.nixFlakes) https://discourse.nixos.org/t/using-experimental-nix-features-in-nixos-and-when-they-will-land-in-stable/7401/4
  };
  boot = {
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot.enable = true;
    initrd.luks.devices = {
      root = {
        device =
          "/dev/disk/by-uuid/63f4ee07-4fbc-43dc-ada0-50061d58049c"; # Encrypted drive to be mounted by the bootloader. Path of the device will have to be changed for each install.
        preLVM = true;
        allowDiscards = true;
      };
    };
    tmp.cleanOnBoot = true; # /tmp is cleaned after each reboot
    # trace: warning: The option `boot.cleanTmpDir' defined in `/etc/nixos/configuration.nix' has been renamed to `boot.tmp.cleanOnBoot'.

  };
  boot = { kernel = { sysctl = { "net.ipv4.conf.all.forwarding" = true; }; }; };

  systemd.services.NetworkManager-wait-online.enable =
    false; # https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;

  time.timeZone = "Europe/London"; # Set your time zone.
  i18n.defaultLocale = "en_GB.UTF-8"; # Select internationalisation properties.
  console = {
    font = "Lat2-Terminus16";
    keyMap = "uk";
  };

  networking.hostName = "avingate"; # Define your hostname.
  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;
  networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.
  networking.wireless.networks."Optus_B818_D3DA_5G".psk = "9L24F93320B";
  
  networking.firewall = {
    allowedUDPPorts = [ 2200 21027 51820 ];
    allowedTCPPorts = [ 8384 22000 ];
  };
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [
        "10.100.0.3/24"
      ]; # Determines the IP address and subnet of the client's end of the tunnel interface.
      listenPort =
        51820; # to match firewall allowedUDPPorts (without this wg uses random port numbers)
      privateKeyFile =
        "/home/nrb/wireguard-keys/private"; # Path to the private key file.
      peers =
        [ # umask 077; mkdir ~/wireguard-keys; wg genkey > ~/wireguard-keys/private; wg pubkey < ~/wireguard-keys/private > ~/wireguard-keys/public; cat ~/wireguard-keys/public
          {
            publicKey = "K8ZWWNRf6wFhGQ1fpewNelM5jOadRSOK9OpakmfcnV0=";
            allowedIPs = [ "10.100.0.0/24" ];
            endpoint = "51.195.200.156:51820"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577
            persistentKeepalive =
              25; # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          }
          # self { publicKey = "YIfEx4ONFSjH0po3TLGQkTVrW7c4BaJP49czHzvzAUM="; allowedIPs = [ "10.100.0.3/32" ]; } # avingate 
        ];
    };
  };
/* 
Nigel Bray - EPI2WFY - Hisense HNR320T wants to share folder "LK8000" (LK8000). Add new folder?
Nigel Bray - EPI2WFY - Hisense HNR320T wants to share folder "itow.uk" (itow.uk). Share this folder?
Nigel Bray - EPI2WFY - Hisense HNR320T wants to share folder "sm-a217f_gsa5-photos" (sm-a217f_gsa5-photos). Add new folder? 
*/
  services = { # https://nixos.wiki/wiki/Syncthing
    syncthing = { # https://search.nixos.org/options?channel=23.11&from=0&size=30&sort=relevance&type=packages&query=services.syncthing.settings.options 

      enable = true;
      user = "nrb";
      # https://github.com/NixOS/nixpkgs/issues/85336#issuecomment-1287781419
      dataDir = "/home/nrb/dir/sync";    # Default folder for new synced folders
      configDir = "/home/nrb/.config/syncthing-new";   # Folder for Syncthing's settings and keys
      guiAddress = "0.0.0.0:8384";
      #settings.options = { "relayReconnectIntervalM" = "10" "startBrowser" = "false" };       
      settings.devices = {  # services.syncthing.settings.devices
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
      settings.folders = {
        "LK8000" = { path = "/home/nrb/dir/sync/LK8000";  devices = [ "Nigel Bray - D36E34G - mintanin" "Nigel Bray - TLWZV5Y - avingate" "Nigel Bray - Z7QLQCQ - redwider" "Nigel Bray - EPI2WFY - Hisense HNR320T" "Nigel Bray - SAOTSZQ - vps221852" "Nigel Bray - EZPA4DH - servmail" ]; };  #ID = "amsl.consulting"; 
        "itow.uk" = { path = "/home/nrb/dir/sync/itow.uk";  devices = [ "Nigel Bray - D36E34G - mintanin" "Nigel Bray - TLWZV5Y - avingate" "Nigel Bray - Z7QLQCQ - redwider" "Nigel Bray - EPI2WFY - Hisense HNR320T" "Nigel Bray - SAOTSZQ - vps221852" "Nigel Bray - EZPA4DH - servmail" ]; };  #ID = "amsl.consulting"; 
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

  users.users.git.group = "git";
  users.groups.git.members = [ "git" "nrb" ] ;

  users.users.git = {
    isSystemUser = true;
    description = "git user";
    home = "/srv/local/git/";
    shell = "${pkgs.git}/bin/git-shell";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHGXa5qbZS3vXSkT4EcJDMp2IBOmeI0pu20wtHEiGb5A"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHbHmtDN6rrYtJoBtCce9jh6b4LHVuCzFqdpIzIEiCHI nrb@dubedary"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII62Xn7RMpaVkB820nigFuRWMBWh0uwheYKmvo28wSBy nrb@avingate"
    ];
  };

  users.users.nrb = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };
  environment.systemPackages = with pkgs; [
    git
    ripgrep
    jq
    wget
    tmux
    bind
    host
    traceroute
    nmap
    ethtool
    pass
    wireguard-tools
  ];

  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "prohibit-password";
  services.sshd.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHGXa5qbZS3vXSkT4EcJDMp2IBOmeI0pu20wtHEiGb5A"
  ];
  system.stateVersion = "20.09"; # Did you read the comment?

  networking.useNetworkd = true; 
  networking.nat = {
    enable = true;
    internalInterfaces = [ "enp3s0" ];
    externalInterface = "wlp2s0";
  };

  networking.interfaces.enp3s0.ipv4.addresses = [{
    address = "192.168.10.1";
    prefixLength = 24;
  }];
  systemd.network = {
    enable = true;
    networks.enp3s0 = {
      matchConfig.Name = "enp3s0";
      dhcpServerConfig = {
        # UplinkInterface = wlp2s0; 
        UplinkInterface = ":auto"; # default
        # Router = 
      };
      address = [ "192.168.10.1/24" ];
      gateway = [ "192.168.9.1" ];
      networkConfig = { # Each attribute in this set specifies an option in the [Network] section of systemd.network(5)
        IPMasquerade = "ipv4";
        IPForward = true;
      };
    };
  };

}
