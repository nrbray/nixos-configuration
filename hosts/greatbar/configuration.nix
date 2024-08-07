{ config, lib, ... }:
{
  imports = [
    # ./server.nix # turn the server off.  Is non-functional and only there to test the configuration for the actual server.
    ./hardware-configuration.nix 
    ./trust.nix 
    ./wireguard.nix 
    ../../modules/system.nix 
    ../../users/git.nix 
  ];
  system.stateVersion = "23.11";
  zramSwap.enable = true;
  networking.hostName = "greatbar";
  # networking.firewall.extraCommands = "iptables -t nat -A POSTROUTING -d 10.100.0.3 -p tcp -m tcp --dport 22 -j MASQUERADE";
  # networking.nat.forwardPorts = [ { proto = "tcp"; sourcePort = 2222; destination = "10.100.0.3:22"; } ];
}
