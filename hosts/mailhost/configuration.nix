{ config, pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix 
    ./mail.nix 
    ./trust.nix 
    ../../modules/system.nix 
  ];
  environment.defaultPackages = lib.mkForce [ ];
  system.stateVersion = "23.11";
  zramSwap.enable = true;
  networking.hostName = "mailhost";
  environment.systemPackages = with pkgs; [ wireguard-tools ];
}
