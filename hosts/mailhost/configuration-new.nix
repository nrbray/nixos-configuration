{ config, pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix 
    ./mail.nix 
    ./trust.nix 
    ../../modules/system.nix 
  ];
  system.stateVersion = "23.11";
  zramSwap.enable = true;
  networking.hostName = "mailhost";
}
