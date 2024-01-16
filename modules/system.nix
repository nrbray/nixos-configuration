{ pkgs, lib, ... }: { 

  nix.settings.experimental-features = ["nix-command" "flakes"];
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.
  networking.wireless.networks."Optus_B818_D3DA_5G".psk = "9L24F93320B";
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "uk";
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [ git tmux ripgrep ];
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "prohibit-password";
  services.sshd.enable = true;

}