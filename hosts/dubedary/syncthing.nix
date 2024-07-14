{ config, pkgs, ... }: { 
  networking.firewall = {
    allowedUDPPorts = [ 2200 21027 ];
    allowedTCPPorts = [ 8384 22000 ];
  };
  services = { # https://nixos.wiki/wiki/Syncthing
    syncthing = { # https://search.nixos.org/options?channel=23.11&from=0&size=30&sort=relevance&type=packages&query=services.syncthing.settings
      enable = true;
      user = "nrb";
      # https://github.com/NixOS/nixpkgs/issues/85336#issuecomment-1287781419
      dataDir = "/home/nrb/Documents";    # Default folder for new synced folders
      configDir = "/home/nrb/.config/syncthing";   # Folder for Syncthing's settings and keys file://home/nrb/.config/syncthing/config.xml.20231208 
      guiAddress = "0.0.0.0:8384";
      overrideDevices = true;
      settings.devices = {  
        "Nigel Bray - D36E34G - mintanin" = { id = "D36E34G-HZLITDX-UHTERSJ-W2PE4ZJ-7HWLIJG-OUNY5KA-PHFNNCA-WPQ7FAN"; };
        "Nigel Bray - EPI2WFY - Hisense HNR320T" = { id = "EPI2WFY-PCWBH6P-QN3PYRX-IRBFNBI-MFSBFVR-NJTHUNO-CIVH4IS-2RCYFQR"; };
        "Nigel Bray - EZPA4DH - servmail" = { id = "EZPA4DH-7NG4U4Y-BJ2DNJH-NUHRZTU-EZVSMHL-GUG65WP-HINFLJY-5JZ3XA4"; };
        "Nigel Bray - LUB2Z3Y - gionvert" = { id = "LUB2Z3Y-GXRIX3W-GDZ7S7J-FCA4XXU-YHARCVJ-OJNRLJS-JOSNG7W-T2PUZAO"; };
        "Nigel Bray - PV3RQAM - moto g(50)" = { id = "PV3RQAM-FCX5TCL-ZSVD7RG-3Y56FMB-T2FNYWS-USPMP6B-5MJCUQ6-7IGH5QG"; };
        "Nigel Bray - SAOTSZQ - vps221852" = { id = "SAOTSZQ-MW5XXRE-YBOVKGB-XPUPAXJ-RCBMNWP-G5UWICP-HEAELXN-6I3W7QB"; };
        "Nigel Bray - TLWZV5Y - avingate" = { id = "TLWZV5Y-HDNSG76-WD4KAL7-DPNYIPZ-D2C3JLR-FZND3FD-TGQ7KQU-HAUG6QJ"; };
        "Nigel Bray - Z7QLQCQ - redwider" = { id = "Z7QLQCQ-ZGNJCIW-42D57PP-MFPDXLN-7VLZXME-AFI37SE-IBVGHIK-7UVQCAC"; };
      };
      overrideFolders = true;
      settings.folders = {
      };
    };
  };
}