{ pkgs, lib, ... }: { 
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.wireless.networks."SoftRF-5ce608".psk = "12345678";
  networking.wireless.networks."Optus_B818_D3DA".psk = "9L24F93320B";
  networking.wireless.networks."Optus_B818_D3DA_5G" = {
      priority = 2;
      psk = "9L24F93320B";
    };
  networking.wireless.networks."BTWholeHome-87M".psk = "aubergine0";
  networking.wireless.networks."CGC".psk = "CBSIFTBEC";
  networking.wireless.networks."Nigel's moto g(50)_6318" = {
      priority = 5;
      psk = "aubergine";
    };
  networking.wireless.networks."BGGC Guest" = {
      authProtocols = [ "NONE" ];
    };
  networking.wireless.networks."A7 CC" = {
      priority = 4;
      psk = "aubergine";
    };
  networking.wireless.networks."A7 CC original" = {
      priority = 3;
      psk = "aubergine";
    };
  networking.wireless.networks."BT-K8CM7P".psk = "bdJknkGvrdquq4";
  networking.wireless.networks."MASIA SERRET 4".psk = "masiaserret4";
  networking.wireless.networks."MASIA SERRET 3".psk = "masiaserret3";
  networking.wireless.networks."SFR_3B7F".psk = "7hx7wh5zgpdj1ub89lg3";
  # note use command line commands (/home/nrb/dir/WIP/nixos-configuration/ni) to connect, then use the link to rebuild...
}