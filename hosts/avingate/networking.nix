{ config, pkgs, lib, ... }: {
  networking.hostName = "avingate"; # Define your hostname.
  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;
  networking.useNetworkd = true; 
  networking.nat = {
    enable = true;
    internalInterfaces = [ "enp3s0" ];
    externalInterface = "wlp2s0";
  };
  networking.interfaces.enp3s0.ipv4.addresses = [{
    address = "192.168.10.1";
    prefixLength = 24;
  }];
  systemd.services.NetworkManager-wait-online.enable = false; # https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;
  systemd.network = {
    enable = true;
    networks.enp3s0 = {
      matchConfig.Name = "enp3s0";
      dhcpServerConfig = {
        # UplinkInterface = wlp2s0; 
        UplinkInterface = ":auto"; # default
        # Router = 
      };
      address = [ "192.168.10.1/24" ];
      gateway = [ "192.168.9.1" ];
      networkConfig = { # Each attribute in this set specifies an option in the [Network] section of systemd.network(5)
        IPMasquerade = "ipv4";
        IPForward = true;
      };
    };
  };
}