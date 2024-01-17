{ config, pkgs, ... }: { 
  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
    allowedTCPPorts = [ ]; };
  environment.systemPackages = with pkgs; [ wireguard-tools ];
  systemd.network = {
    enable = true;
    netdevs = {
      "50-wg0" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wg0";
          MTUBytes = "1300";
        };
        wireguardConfig = {
          PrivateKeyFile = "/etc/systemd/network/wireguard";
          ListenPort = 51820;
        };
        wireguardPeers = [
          { wireguardPeerConfig = { 
            PublicKey = "K8ZWWNRf6wFhGQ1fpewNelM5jOadRSOK9OpakmfcnV0="; 
            # AllowedIPs = [ "10.100.0.0/24" ]; # https://www.procustodibus.com/blog/2021/03/wireguard-allowedips-calculator/
            AllowedIPs = [  "0.0.0.0/3" "32.0.0.0/4" "48.0.0.0/7" "50.0.0.0/8" "51.0.0.0/9" "51.128.0.0/10" "51.192.0.0/15" "51.194.0.0/16" "51.195.0.0/17" "51.195.128.0/18" "51.195.192.0/21" "51.195.200.0/25" "51.195.200.128/28" "51.195.200.144/29" "51.195.200.152/30" "51.195.200.157/32" "51.195.200.158/31" "51.195.200.160/27" "51.195.200.192/26" "51.195.201.0/24" "51.195.202.0/23" "51.195.204.0/22" "51.195.208.0/20" "51.195.224.0/19" "51.196.0.0/14" "51.200.0.0/13" "51.208.0.0/12" "51.224.0.0/11" "52.0.0.0/6" "56.0.0.0/5" "64.0.0.0/2" "128.0.0.0/1" ];
            Endpoint = "51.195.200.156:51820";
            PersistentKeepalive = 25; # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          }; } # servmail
        # { wireguardPeerConfig = { PublicKey = "H15gzMI1Q7Au7p8tO+FKeyB08IHdB05KWaP90PXUZ1E="; AllowedIPs = [ "10.100.0.2" ]; }; } # mintanin 
        # { wireguardPeerConfig = { PublicKey = "YIfEx4ONFSjH0po3TLGQkTVrW7c4BaJP49czHzvzAUM="; AllowedIPs = [ "10.100.0.3" ]; }; } # avingate 
        # { wireguardPeerConfig = { PublicKey = "wGBgYqr9B6ieWXAV1ybMUwl11lRtk3PpM0vzYkURy3E="; AllowedIPs = [ "10.100.0.4" ]; }; } # a7cc 
        ];
      };
    };
    networks.wg0 = {
      matchConfig.Name = "wg0";
      address = ["10.100.0.2/24"];            # { publicKey = "K8ZWWNRf6wFhGQ1fpewNelM5jOadRSOK9OpakmfcnV0="; allowedIPs = [ "10.100.0.1/32" ]; } # servmail 
      DHCP = "no";
      # gateway = [ "10.100.0.1" ]; # sudo ip route add 51.195.200.156 via 192.168.8.1 dev wlp4s0; sudo ip route del default via 192.168.8.1 dev wlp4s0; sudo ip route add default via 10.100.0.1 dev wg0; ip r
      networkConfig = {
        IPv6AcceptRA = false;
      };
    };
  };
}