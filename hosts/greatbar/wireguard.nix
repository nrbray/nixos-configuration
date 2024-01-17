{ pkgs, ... }: {
  # boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  environment.systemPackages = with pkgs; [ wireguard-tools ];
  networking.firewall.allowedTCPPorts = [  ];
  networking.firewall.allowedUDPPorts = [ 51820 ];
  networking.useNetworkd = true;
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
          { wireguardPeerConfig = { PublicKey = "H15gzMI1Q7Au7p8tO+FKeyB08IHdB05KWaP90PXUZ1E="; AllowedIPs = [ "10.100.0.2" ]; }; } # mintanin 
          { wireguardPeerConfig = { PublicKey = "YIfEx4ONFSjH0po3TLGQkTVrW7c4BaJP49czHzvzAUM="; AllowedIPs = [ "10.100.0.3" ]; }; } # avingate 
          { wireguardPeerConfig = { PublicKey = "wGBgYqr9B6ieWXAV1ybMUwl11lRtk3PpM0vzYkURy3E="; AllowedIPs = [ "10.100.0.4" ]; }; } # a7cc1 
          { wireguardPeerConfig = { PublicKey = "sLKSS8bLmyn1a0vtBi23QUn/eJAN5UW1Q7gUU/rPFg4="; AllowedIPs = [ "10.100.0.5" ]; }; } # dubedary 
          # { publicKey = "K8ZWWNRf6wFhGQ1fpewNelM5jOadRSOK9OpakmfcnV0="; allowedIPs = [ "10.100.0.1/32" ]; } # servmail 
        ];
      };
    };
    networks.wg0 = {
      matchConfig.Name = "wg0";
      address = ["10.100.0.1/24"];            
      networkConfig = {
        IPMasquerade = "ipv4";
        IPForward = "ipv4";
      };
    };
  };
}