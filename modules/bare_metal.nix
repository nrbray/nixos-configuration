{ pkgs, lib, ... }: { 
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.wireless.networks."Optus_B818_D3DA".psk = "9L24F93320B";
  networking.wireless.networks."Optus_B818_D3DA_5G".psk = "9L24F93320B";
  networking.wireless.networks."BTWholeHome-87M".psk = "aubergine0";
  networking.wireless.networks."CGC".psk = "CBSIFTBEC";
  networking.wireless.networks."Nigel's moto g(50)_6318".psk = "aubergine";
  networking.wireless.networks."A7 CC".psk = "aubergine";
  networking.wireless.networks."BT-K8CM7P".psk = "bdJknkGvrdquq4";
}