{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix 
    ./trust.nix 
    # ./wireguard.nix 
    ./syncthing.nix
    # ./networking.nix
    ../../modules/bare_metal.nix  
    ../../modules/system.nix 
    ../../users/nrb.nix 
    # ../../users/git.nix 
  ]; 
  environment.defaultPackages = lib.mkForce [];
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
  networking.firewall.allowedTCPPorts = [ 143 465 587 993 8384 22000 ];  # Syncthing ports + wireguard
  networking.firewall.allowedUDPPorts = [ 22000 21027 51820 ];
  # systemd.services.NetworkManager-wait-online.enable = false; # https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;
  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "btrfs";
  # users.users.nrb.extraGroups = [ "docker" ];
  programs.nix-ld.enable = true; # https://github.com/Mic92/nix-ld
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
  users.users.nrb.packages = with pkgs; [
    weechat tdesktop whatsapp-for-linux 
    deltachat-desktop mutt gnome3.geary 
    vscodium lapce
    bitwarden 
    libreoffice  
    wine winetricks # rm -rf $HOME/.wine; rm -f $HOME/.config/menus/applications-merged/*wine*; rm -rf $HOME/.local/share/applications/wine; rm -f $HOME/.local/share/desktop-directories/*wine*
    ungoogled-chromium
    nushell 
    alacritty 
  ];
  programs.gnupg.agent = { enable = true; }; # https://github.com/NixOS/nixpkgs/issues/210375 # pinentryFlavor = "gtk2"; # enableSSHSupport = true;
  environment.systemPackages = with pkgs; [ jq wget bind host traceroute nmap ethtool pass wireguard-tools nixfmt nixpkgs-fmt rnix-lsp bitwarden-cli distrobox steam-run nix-index ]; # https://github.com/NixOS/nixpkgs/issues/271722   
  system.stateVersion = "22.11"; # Did you read the comment?
}
