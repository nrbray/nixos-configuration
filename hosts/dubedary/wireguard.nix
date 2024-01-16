{ config, pkgs, ... }: { 
  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
    allowedTCPPorts = [  ]; };
  environment.systemPackages = with pkgs; [ wireguard-tools ];
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.100.0.5/24" ]; # Determines the IP address and subnet of the client's end of the tunnel interface.
      listenPort = 51820; # to match firewall allowedUDPPorts (without this wg uses random port numbers)
      privateKeyFile = "/home/nrb/wireguard-keys/private"; # Path to the private key file.
      peers =
        [ # umask 077; mkdir ~/wireguard-keys; wg genkey > ~/wireguard-keys/private; wg pubkey < ~/wireguard-keys/private > ~/wireguard-keys/public; cat ~/wireguard-keys/public
          {
            publicKey = "K8ZWWNRf6wFhGQ1fpewNelM5jOadRSOK9OpakmfcnV0=";
            allowedIPs = [ "10.100.0.0/24" ];
            endpoint = "51.195.200.156:51820"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577
            persistentKeepalive = 25; # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          }
          # self { publicKey = "sLKSS8bLmyn1a0vtBi23QUn/eJAN5UW1Q7gUU/rPFg4="; allowedIPs = [ "10.100.0.5/32" ]; } # dubedary 
        ];
    };
  };
}