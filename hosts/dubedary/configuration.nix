
{ config, pkgs, ... }:
{
  imports = [ 
    ./hardware-configuration.nix 
    #./desktop.nix
    ./trust.nix 
    ./wireguard.nix 
    #./syncthing.nix
    #./networking.nix
    ../../modules/system.nix 
    ../../modules/bare_metal.nix 
    ../../users/nrb.nix ];
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.initrd.secrets = { "/crypto_keyfile.bin" = null; };
  boot.initrd.luks.devices."dbae75f6-e73a-483b-8d31-9e9f27833387".device = "/dev/disk/by-uuid/dbae75f6-e73a-483b-8d31-9e9f27833387";
  boot.initrd.luks.devices."dbae75f6-e73a-483b-8d31-9e9f27833387".keyFile = "/crypto_keyfile.bin";
  networking.hostName = "dubedary";
  system.stateVersion = "23.11"; # Did you read the comment?
}
