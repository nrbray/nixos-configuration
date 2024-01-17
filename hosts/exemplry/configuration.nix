
{ config, pkgs, ... }:
{
  boot.initrd.luks.devices."dbae75f6-e73a-483b-8d31-9e9f27833387".device = "/dev/disk/by-uuid/dbae75f6-e73a-483b-8d31-9e9f27833387";
  boot.initrd.luks.devices."dbae75f6-e73a-483b-8d31-9e9f27833387".keyFile = "/crypto_keyfile.bin";
  boot.initrd.secrets = { "/crypto_keyfile.bin" = null; };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.systemd-boot.enable = true;
  environment.systemPackages = with pkgs; [ ];
  imports = [ ./hardware-configuration.nix ];
  networking.hostName = "exemplry";
  networking.networkmanager.enable = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "23.11"; # Did you read the comment?
  time.timeZone = "Europe/London"; i18n.defaultLocale = "en_GB.UTF-8"; console.keyMap = "uk";
  users.groups.nrb.members = [ "nrb" ] ;
  users.users.nrb = { isNormalUser = true; group = "nrb"; extraGroups = [ "networkmanager" "wheel" ]; };
}
