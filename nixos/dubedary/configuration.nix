
{ config, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];
  nix = { 
    package = pkgs.nixFlakes; 
    extraOptions =  "experimental-features = nix-command flakes"; 
  };
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.initrd.secrets = { "/crypto_keyfile.bin" = null; };
  boot.initrd.luks.devices."dbae75f6-e73a-483b-8d31-9e9f27833387".device = "/dev/disk/by-uuid/dbae75f6-e73a-483b-8d31-9e9f27833387";
  boot.initrd.luks.devices."dbae75f6-e73a-483b-8d31-9e9f27833387".keyFile = "/crypto_keyfile.bin";
  networking.hostName = "dubedary";
  networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.
  networking.wireless.networks."Optus_B818_D3DA_5G".psk = "9L24F93320B";
  networking.firewall = {
    allowedUDPPorts = [ 2200 21027 51820 ];
    allowedTCPPorts = [ 8384 22000 ];
  };
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
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "uk";
  users.users.nrb = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHGXa5qbZS3vXSkT4EcJDMp2IBOmeI0pu20wtHEiGb5A" ];  
  };
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [ git tmux wireguard-tools ];
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "prohibit-password";
  services.sshd.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHGXa5qbZS3vXSkT4EcJDMp2IBOmeI0pu20wtHEiGb5A" ];  
  system.stateVersion = "23.11"; # Did you read the comment?
}
