{ config, pkgs, lib, myappattribute, ... }: {
  imports = [
    ./hardware-configuration.nix 
    ./trust.nix 
    ./wireguard.nix 
    ./syncthing.nix
    ./networking.nix
    ../../modules/bare_metal.nix  
    ../../modules/system.nix 
    ../../users/nrb.nix 
    ../../users/git.nix
  ];
  system.stateVersion = "20.09"; # Did you read the comment?
  environment.systemPackages = with pkgs; [ jq wget bind host traceroute nmap ethtool pass ] ++ [ myappattribute.packages.x86_64-linux.default ];
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
}
