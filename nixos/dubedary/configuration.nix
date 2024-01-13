
{ config, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];
  nix = { 
    package = pkgs.nixFlakes; 
    extraOptions =  "experimental-features = nix-command flakes"; 
  };
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.initrd.secrets = { "/crypto_keyfile.bin" = null; };
  boot.initrd.luks.devices."dbae75f6-e73a-483b-8d31-9e9f27833387".device = "/dev/disk/by-uuid/dbae75f6-e73a-483b-8d31-9e9f27833387";
  boot.initrd.luks.devices."dbae75f6-e73a-483b-8d31-9e9f27833387".keyFile = "/crypto_keyfile.bin";
  networking.hostName = "dubedary";
  networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.
  networking.wireless.networks."Optus_B818_D3DA_5G".psk = "9L24F93320B";
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "uk";
  users.users.nrb = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHGXa5qbZS3vXSkT4EcJDMp2IBOmeI0pu20wtHEiGb5A" ];  
  };
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [ ];
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "prohibit-password";
  services.sshd.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHGXa5qbZS3vXSkT4EcJDMp2IBOmeI0pu20wtHEiGb5A" ];  
  system.stateVersion = "23.11"; # Did you read the comment?
}
