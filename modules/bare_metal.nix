{ pkgs, lib, ... }: { 
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.
  networking.wireless.networks."Optus_B818_D3DA_5G".psk = "9L24F93320B";
}