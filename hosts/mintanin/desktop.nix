{ config, pkgs, ... }: {
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
}