{ config, pkgs, ... }: {
  services.xserver.enable = true;  # Enable the X11 windowing system.
  services.xserver.displayManager.gdm.enable = true;  # login display manager https://unix.stackexchange.com/questions/131496/what-is-lightdm-and-gdm
  services.xserver.desktopManager.gnome.enable = true; # Enable the GNOME Desktop Environment. 
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
    tdesktop 
    gnome3.geary 
    lapce
    bitwarden 
    alacritty 
    fractal
    xclip
  ];
  programs.gnupg.agent = { enable = true; }; # https://github.com/NixOS/nixpkgs/issues/210375 # pinentryFlavor = "gtk2"; # enableSSHSupport = true;
  environment.systemPackages = with pkgs; [ jq wget bind host traceroute nmap ethtool pass nil bitwarden-cli ]; # https://github.com/NixOS/nixpkgs/issues/271722   
}