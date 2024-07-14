{ config, pkgs, lib, myappattribute, ... }:
{
  imports = [
    ./hardware-configuration.nix
    #../../modules/desktop.nix 
    ./trust.nix
    #./wireguard.nix
    #./syncthing.nix
    ./networking.nix
    ../../modules/bare_metal.nix
    ../../modules/system.nix
    ../../users/nrb.nix
    #../../users/git.nix
  ];
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.initrd.secrets = { "/crypto_keyfile.bin" = null; };
  boot.initrd.luks.devices."e219859a-5393-4dcb-b300-40aedbb810c7".device = "/dev/disk/by-uuid/e219859a-5393-4dcb-b300-40aedbb810c7";
  boot.initrd.luks.devices."e219859a-5393-4dcb-b300-40aedbb810c7".keyFile = "/crypto_keyfile.bin";
  networking.hostName = "lojijove";
  system.stateVersion = "23.11"; # Did you read the comment?
}
