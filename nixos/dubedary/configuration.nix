
{ config, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];
  nix = {
    package = pkgs.nixFlakes; # https://www.breakds.org/post/flake-part-1-packaging/
    extraOptions =  "experimental-features = nix-command flakes"; # lib.optionalString (config.nix.package == pkgs.nixFlakes) https://discourse.nixos.org/t/using-experimental-nix-features-in-nixos-and-when-they-will-land-in-stable/7401/4
  };
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.initrd.secrets = { "/crypto_keyfile.bin" = null; };
  boot.initrd.luks.devices."partition_uuid".device = "/dev/disk/by-uuid/partition_uuid";
  boot.initrd.luks.devices."partition_uuid".keyFile = "/crypto_keyfile.bin";
  networking.hostName = "dubedarydubedary"; # Define your hostname.
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "uk";
  users.users.nrb = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [ ];
  system.stateVersion = "23.11"; # Did you read the comment?
}
