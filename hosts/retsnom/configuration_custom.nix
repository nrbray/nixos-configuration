{ config, pkgs, lib, myappattribute, ... }:
{
  # host specific
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "retsnom";
  system.stateVersion = "24.05"; # Did you read the comment?
  # sudo nix-store --verify --repair --check-contents

  imports = [
    ./hardware-configuration.nix
   # ../../modules/desktop.nix 
    ./trust.nix
    #./wireguard.nix
    # ./syncthing.nix
    ./networking.nix
    ../../modules/bare_metal.nix
    ../../modules/system.nix
    ../../users/nrb.nix
    ../../users/git.nix
  ];

}
