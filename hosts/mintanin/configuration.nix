{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix 
    ./trust.nix 
    ./wireguard.nix 
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
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];
  # systemd.services.NetworkManager-wait-online.enable = false; # https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;
  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "btrfs";
  # users.users.nrb.extraGroups = [ "docker" ];
  programs.nix-ld.enable = true; # https://github.com/Mic92/nix-ld

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
  environment.systemPackages = with pkgs; [ jq wget bind host traceroute nmap ethtool pass nixfmt nixpkgs-fmt rnix-lsp bitwarden-cli distrobox steam-run nix-index ]; # https://github.com/NixOS/nixpkgs/issues/271722   
  system.stateVersion = "22.11"; # Did you read the comment?
}
