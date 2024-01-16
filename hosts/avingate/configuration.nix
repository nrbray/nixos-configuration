{ config, pkgs, lib, ... }: {
  imports = [
    ./hardware-configuration.nix 
    ./trust.nix 
    ./wireguard.nix 
    ./syncthing.nix
    ../../modules/bare_metal.nix  
    ../../modules/system.nix 
    ../../users/nrb.nix 
    ../../users/git.nix
  ];
  system.stateVersion = "20.09"; # Did you read the comment?
  environment.systemPackages = with pkgs; [ jq wget bind host traceroute nmap ethtool pass ];
  boot = {
    initrd.luks.devices = {
      root = {
        device = "/dev/disk/by-uuid/63f4ee07-4fbc-43dc-ada0-50061d58049c"; # Encrypted drive to be mounted by the bootloader. Path of the device will have to be changed for each install.
        preLVM = true;
        allowDiscards = true;
      };
    };
    kernel = { sysctl = { "net.ipv4.conf.all.forwarding" = true; }; }; 
   };
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
