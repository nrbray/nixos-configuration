{ config, pkgs, ... }: { 
  networking.firewall = {
    allowedUDPPorts = [ 2200 21027 ];
    allowedTCPPorts = [ 8384 22000 ];
  };
  services = { # https://nixos.wiki/wiki/Syncthing
    syncthing = { # https://search.nixos.org/options?channel=23.11&from=0&size=30&sort=relevance&type=packages&query=services.syncthing.settings.options 
      enable = true;
      user = "nrb";
      # https://github.com/NixOS/nixpkgs/issues/85336#issuecomment-1287781419
      dataDir = "/home/nrb/dir/sync";    # Default folder for new synced folders
      configDir = "/home/nrb/.config/syncthing-new";   # Folder for Syncthing's settings and keys
      guiAddress = "0.0.0.0:8384";
      #settings.options = { "relayReconnectIntervalM" = "10" "startBrowser" = "false" };       
      settings.devices = {  # services.syncthing.settings.devices
        "Nigel Bray - 5T5MQUY - dellsman" = { id = "5T5MQUY-VDB67JA-SEJDHWW-TVTZ7V5-B6KXN7O-XLMSD7G-KAAR7IE-QL3GVAM"; };
        "Nigel Bray - D36E34G - mintanin" = { id = "D36E34G-HZLITDX-UHTERSJ-W2PE4ZJ-7HWLIJG-OUNY5KA-PHFNNCA-WPQ7FAN"; };
        "Nigel Bray - EPI2WFY - Hisense HNR320T" = { id = "EPI2WFY-PCWBH6P-QN3PYRX-IRBFNBI-MFSBFVR-NJTHUNO-CIVH4IS-2RCYFQR"; };
        "Nigel Bray - EZPA4DH - servmail" = { id = "EZPA4DH-7NG4U4Y-BJ2DNJH-NUHRZTU-EZVSMHL-GUG65WP-HINFLJY-5JZ3XA4"; };
        "Nigel Bray - LUB2Z3Y - gionvert" = { id = "LUB2Z3Y-GXRIX3W-GDZ7S7J-FCA4XXU-YHARCVJ-OJNRLJS-JOSNG7W-T2PUZAO"; };
        "Nigel Bray - PV3RQAM - moto g(50)" = { id = "PV3RQAM-FCX5TCL-ZSVD7RG-3Y56FMB-T2FNYWS-USPMP6B-5MJCUQ6-7IGH5QG"; };
        "Nigel Bray - SAOTSZQ - vps221852" = { id = "SAOTSZQ-MW5XXRE-YBOVKGB-XPUPAXJ-RCBMNWP-G5UWICP-HEAELXN-6I3W7QB"; };
        "Nigel Bray - TLWZV5Y - avingate" = { id = "TLWZV5Y-HDNSG76-WD4KAL7-DPNYIPZ-D2C3JLR-FZND3FD-TGQ7KQU-HAUG6QJ"; };
        "Nigel Bray - Z7QLQCQ - redwider" = { id = "Z7QLQCQ-ZGNJCIW-42D57PP-MFPDXLN-7VLZXME-AFI37SE-IBVGHIK-7UVQCAC"; };
      };
      settings.folders = {
        "LK8000" = { path = "/home/nrb/dir/sync/LK8000";  devices = [ "Nigel Bray - D36E34G - mintanin" "Nigel Bray - TLWZV5Y - avingate" "Nigel Bray - Z7QLQCQ - redwider" "Nigel Bray - EPI2WFY - Hisense HNR320T" "Nigel Bray - SAOTSZQ - vps221852" "Nigel Bray - EZPA4DH - servmail" ]; };  #ID = "amsl.consulting"; 
        "itow.uk" = { path = "/home/nrb/dir/sync/itow.uk";  devices = [ "Nigel Bray - D36E34G - mintanin" "Nigel Bray - TLWZV5Y - avingate" "Nigel Bray - Z7QLQCQ - redwider" "Nigel Bray - EPI2WFY - Hisense HNR320T" "Nigel Bray - SAOTSZQ - vps221852" "Nigel Bray - EZPA4DH - servmail" ]; };  #ID = "amsl.consulting"; 
        "sm-a217f_gsa5-photos" = { path = "/home/nrb/dir/sync/sm-a217f_gsa5-photos";  devices = [ "Nigel Bray - D36E34G - mintanin" "Nigel Bray - TLWZV5Y - avingate" "Nigel Bray - Z7QLQCQ - redwider" "Nigel Bray - EPI2WFY - Hisense HNR320T" "Nigel Bray - SAOTSZQ - vps221852" "Nigel Bray - EZPA4DH - servmail" ]; };  #ID = "amsl.consulting"; 
        "amsl.consulting" = { path = "/home/nrb/dir/sync/amsl.consulting";  devices = [ "Nigel Bray - D36E34G - mintanin" "Nigel Bray - TLWZV5Y - avingate" "Nigel Bray - Z7QLQCQ - redwider" "Nigel Bray - EPI2WFY - Hisense HNR320T" "Nigel Bray - SAOTSZQ - vps221852" "Nigel Bray - EZPA4DH - servmail" ]; };  #ID = "amsl.consulting"; 
        "AMSLAccounts.git" = { path = "/home/nrb/dir/sync/AMSLAccounts.git";  devices = [ "Nigel Bray - D36E34G - mintanin" "Nigel Bray - TLWZV5Y - avingate" "Nigel Bray - EPI2WFY - Hisense HNR320T" "Nigel Bray - Z7QLQCQ - redwider" "Nigel Bray - SAOTSZQ - vps221852" "Nigel Bray - EZPA4DH - servmail" ]; };  #ID = "AMSLAccounts.git"; 
        "Apk" = { path = "/home/nrb/dir/sync/Apk";  devices = [ "Nigel Bray - D36E34G - mintanin" "Nigel Bray - TLWZV5Y - avingate" "Nigel Bray - Z7QLQCQ - redwider" "Nigel Bray - EPI2WFY - Hisense HNR320T" "Nigel Bray - PV3RQAM - moto g(50)" "Nigel Bray - SAOTSZQ - vps221852" "Nigel Bray - EZPA4DH - servmail" ]; };  #ID = "Apk"; 
        "barotow.uk" = { path = "/home/nrb/dir/sync/barotow.uk";  devices = [ "Nigel Bray - D36E34G - mintanin" "Nigel Bray - TLWZV5Y - avingate" "Nigel Bray - Z7QLQCQ - redwider" "Nigel Bray - EPI2WFY - Hisense HNR320T" "Nigel Bray - SAOTSZQ - vps221852" "Nigel Bray - EZPA4DH - servmail" ]; };  #ID = "barotow.uk"; 
        "cy3zz-tnayq" = { path = "/home/nrb/dir/sync/cy3zz-tnayq";  devices = [ "Nigel Bray - D36E34G - mintanin" "Nigel Bray - TLWZV5Y - avingate" "Nigel Bray - Z7QLQCQ - redwider" "Nigel Bray - EPI2WFY - Hisense HNR320T" "Nigel Bray - PV3RQAM - moto g(50)" "Nigel Bray - SAOTSZQ - vps221852" "Nigel Bray - EZPA4DH - servmail" ]; };  #ID = "Nigel Bray - personal, private, confidential"; 
        "highvizphotography.co.uk" = { path = "/home/nrb/dir/sync/highvizphotography.co.uk";  devices = [  "Nigel Bray - D36E34G - mintanin" "Nigel Bray - TLWZV5Y - avingate" "Nigel Bray - Z7QLQCQ - redwider"  "Nigel Bray - EZPA4DH - servmail" ]; };  #ID = "highvizphotography.co.uk"; 
        "hnr320t_f1tu-photos" = { path = "/home/nrb/dir/sync/hnr320t_f1tu-photos";  devices = [ "Nigel Bray - D36E34G - mintanin" "Nigel Bray - TLWZV5Y - avingate" "Nigel Bray - EPI2WFY - Hisense HNR320T" "Nigel Bray - Z7QLQCQ - redwider" "Nigel Bray - SAOTSZQ - vps221852" "Nigel Bray - EZPA4DH - servmail" ]; };  #ID = "hnr320t_f1tu-photos"; # Hisense  
        "html" = { path = "/home/nrb/dir/sync/html";  devices = [ "Nigel Bray - D36E34G - mintanin" "Nigel Bray - TLWZV5Y - avingate" "Nigel Bray - Z7QLQCQ - redwider" "Nigel Bray - EPI2WFY - Hisense HNR320T" "Nigel Bray - SAOTSZQ - vps221852" "Nigel Bray - EZPA4DH - servmail" ]; };  #ID = "html"; 
        "jnpwu-kakym" = { path = "/home/nrb/dir/sync/jnpwu-kakym";  devices = [ "Nigel Bray - D36E34G - mintanin" "Nigel Bray - TLWZV5Y - avingate" "Nigel Bray - Z7QLQCQ - redwider" "Nigel Bray - SAOTSZQ - vps221852" "Nigel Bray - EZPA4DH - servmail" ]; };  #ID = "bin"; 
        "k6jue-oew75" = { path = "/home/nrb/dir/sync/k6jue-oew75";  devices = [ "Nigel Bray - D36E34G - mintanin" "Nigel Bray - TLWZV5Y - avingate" "Nigel Bray - Z7QLQCQ - redwider" ]; };  #ID = "www.bigfatrepack.org"; 
        "m3fzc-nkgcb" = { path = "/home/nrb/dir/sync/m3fzc-nkgcb";  devices = [ "Nigel Bray - D36E34G - mintanin" "Nigel Bray - TLWZV5Y - avingate" "Nigel Bray - Z7QLQCQ - redwider" "Nigel Bray - EPI2WFY - Hisense HNR320T" "Nigel Bray - SAOTSZQ - vps221852" "Nigel Bray - EZPA4DH - servmail" ]; };  #ID = "m3fzc-nkgcb"; # Aeroplaying.UK
        "moto_g50_g81r-photos" = { path = "/home/nrb/dir/sync/moto_g50_g81r-photos";  devices = [ "Nigel Bray - D36E34G - mintanin" "Nigel Bray - TLWZV5Y - avingate" "Nigel Bray - PV3RQAM - moto g(50)" "Nigel Bray - Z7QLQCQ - redwider" "Nigel Bray - SAOTSZQ - vps221852" "Nigel Bray - EZPA4DH - servmail" ]; };  #ID = "moto_g50_g81r-photos"; 
        "Personal_affairs_in_order" = { path = "/home/nrb/dir/sync/Personal_affairs_in_order";  devices = [ "Nigel Bray - D36E34G - mintanin" "Nigel Bray - TLWZV5Y - avingate" "Nigel Bray - Z7QLQCQ - redwider" "Nigel Bray - EPI2WFY - Hisense HNR320T" "Nigel Bray - SAOTSZQ - vps221852" "Nigel Bray - EZPA4DH - servmail" ]; };  #ID = "Personal_affairs_in_order"; 
        "to1.uk" = { path = "/home/nrb/dir/sync/to1.uk";  devices = [ "Nigel Bray - D36E34G - mintanin" "Nigel Bray - TLWZV5Y - avingate" "Nigel Bray - Z7QLQCQ - redwider" "Nigel Bray - SAOTSZQ - vps221852" "Nigel Bray - EZPA4DH - servmail" ]; };  #ID = "to1.uk"; 
        "whaerotow" = { path = "/home/nrb/dir/sync/whaerotow";  devices = [ "Nigel Bray - D36E34G - mintanin" "Nigel Bray - TLWZV5Y - avingate" "Nigel Bray - Z7QLQCQ - redwider" ]; };  #ID = "whaerotow"; 
        "org.xcsoar" = { path = "/home/nrb/dir/sync/org.xcsoar";  devices = [ "Nigel Bray - D36E34G - mintanin" "Nigel Bray - TLWZV5Y - avingate" "Nigel Bray - Z7QLQCQ - redwider" "Nigel Bray - EPI2WFY - Hisense HNR320T" "Nigel Bray - PV3RQAM - moto g(50)" "Nigel Bray - SAOTSZQ - vps221852" "Nigel Bray - EZPA4DH - servmail" ]; };  #ID = "org.xcsoar"; 
        "XCSoarDatanrb" = { path = "/home/nrb/dir/sync/XCSoarDatanrb";  devices = [ "Nigel Bray - D36E34G - mintanin" "Nigel Bray - TLWZV5Y - avingate" "Nigel Bray - Z7QLQCQ - redwider" "Nigel Bray - EPI2WFY - Hisense HNR320T" "Nigel Bray - PV3RQAM - moto g(50)" "Nigel Bray - SAOTSZQ - vps221852" "Nigel Bray - EZPA4DH - servmail" ]; };  #ID = "XCSoarDatanrb"; 
      };
    };
  };
}