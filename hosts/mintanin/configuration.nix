{ config, pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix 
    ../../modules/desktop.nix 
    ./trust.nix 
    ./wireguard.nix 
    ./syncthing.nix
    ./networking.nix
    ../../modules/bare_metal.nix  
    ../../modules/system.nix 
    ../../users/nrb.nix 
    # ../../users/git.nix 
  ]; 
  boot.initrd.luks.devices."luks-20a1f166-1f1d-4d97-99c2-a9260c817e32".device = "/dev/disk/by-uuid/20a1f166-1f1d-4d97-99c2-a9260c817e32";  # Enable swap on luks
  boot.initrd.luks.devices."luks-20a1f166-1f1d-4d97-99c2-a9260c817e32".keyFile = "/crypto_keyfile.bin";
  boot.initrd.secrets = { "/crypto_keyfile.bin" = null; };
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  environment.defaultPackages = lib.mkForce [];
  networking.hostName = "mintanin"; # Define your hostname.
  system.stateVersion = "22.11"; # Did you read the comment?
}
