{ config, pkgs, lib, ... }: {
  networking.hostName = "mintanin"; # Define your hostname.
  # networking.nameservers = [ "217.160.70.42" "2001:8d8:1801:86e7::1" "178.254.22.166" "2a00:6800:3:4bd::1" "81.169.136.222" "2a01:238:4231:5200::1" "185.181.61.24" "2a03:94e0:1804::1" ]; # https://opennameserver.org/
  networking.networkmanager.enable = false; #  You can not use networking.networkmanager with networking.wireless. Except if you mark some interfaces as <literal>unmanaged</literal> by NetworkManager.
  networking.useNetworkd = true; 
  services.resolved = {
    enable = true;
    dnssec = "false";
    domains = [ "~." ];
    extraConfig = ''
      DNSOverTLS=yes 
      DNS=8.8.8.8 1.1.1.1 2606:4700:4700::1111 1.0.0.1 2606:4700:4700::1001'';
  };
  networking.firewall.allowedTCPPorts = [ ];  # Email server 143 465 587 993
  networking.firewall.allowedUDPPorts = [ ];
  # systemd.services.NetworkManager-wait-online.enable = false; # https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;
}