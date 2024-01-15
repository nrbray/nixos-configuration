# scp ./NixOS/51.195.200.156/configuration.nix root@51.195.200.156:/etc/nixos/configuration.nix; git add ./NixOS/51.195.200.156/configuration.nix; `which ssh` root@51.195.200.156 -- nixos-rebuild switch; `which ssh` nrb@51.195.200.156
# clone from file:///./../servmail/configuration.nix

{ config, pkgs, lib, ... }:

{
  imports = [
    (builtins.fetchTarball {
      # Pick a release version you are interested in and set its hash, e.g.
      url =
        "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/nixos-23.05/nixos-mailserver-nixos-23.05.tar.gz";
      # To get the sha256 of the nixos-mailserver tarball, we can use the nix-prefetch-url command:
      # release="nixos-23.05"; nix-prefetch-url "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/${release}/nixos-mailserver-${release}.tar.gz" --unpack
      sha256 = "1ngil2shzkf61qxiqw11awyl81cr7ks2kv3r3k243zz7v2xakm5c";
    })
    ./hardware-configuration.nix # Include the results of the hardware scan.
  ];

  nix = {
    package =
      pkgs.nixFlakes; # https://www.breakds.org/post/flake-part-1-packaging/
    extraOptions =
      "experimental-features = nix-command flakes"; # lib.optionalString (config.nix.package == pkgs.nixFlakes) https://discourse.nixos.org/t/using-experimental-nix-features-in-nixos-and-when-they-will-land-in-stable/7401/4
  };

  /* environment.defaultPackages = lib.mkForce [ ]; */

  boot.tmp.cleanOnBoot = true;
  system.stateVersion = "23.11";
  zramSwap.enable = true;
  networking.hostName = "greatbar";
  networking.domain = "aerotow.uk";
  networking.firewall.allowedTCPPorts = [  ];
  networking.firewall.allowedUDPPorts = [ 51820 ];
  networking.firewall.extraCommands = "iptables -t nat -A POSTROUTING -d 10.100.0.3 -p tcp -m tcp --dport 22 -j MASQUERADE";
  networking.nat.forwardPorts = [ { proto = "tcp"; sourcePort = 2222; destination = "10.100.0.3:22"; } ];

  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "prohibit-password";
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDqsazlhOhBl2bmUbvnsLLYeuLBfVrLsfOt5nv3FKw9Nui1y7PmiTacU+CEDex3gLAA6KLP8a+o4uPH1y16L/ZJhADqc6cuYcnFIyMWgsO2TfFz5SUmsgSFN3FUZuJ1aMdp+hz0o2pUZIwKVAy/LwvPzvWmTlcgyQOBMWKqD/lm+KKSAV87OcnRhdhDj2/36QxDVI+5dG5yQJ0xR7mcmUxADEtrkH1ONM7a4M+or9T7285+zlXwsxkGDTKHCULHx0gfaUP5Xph4WfHFcmbKWZ+RygUWYHC/I8xHfvP4EFvPIZfv8jppysDx9sLpMsUiLylbkJ298L+Grq/H6QYc/QZG6LDF0dzqgxpAzKWjOeYBiUZ2HQ9nHNDZiWsQb6+Ai8MnRC0irPXFvYkMooNj+9JEZ5LXnm7WA4/Z99wz0Ucd3cYTazpB+H+BkK07wdecsXIC0C/bTsVo4wUSGkrezRv6Im6Mxp4Ag90FDaW3d0OmOQhiXaMsoa1p3LhT+F1zY+c= nrb@nixos"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDf+wIUgLHwwb19+b8siWPnQMiHSA0Vj/C8jGVvCWUa2 root@vps-6ec22220"
  ];

  security.acme.acceptTerms = true;
  security.acme.defaults.email = "security@bigfatrepack.org";
  mailserver = {
    enable = true;
    fqdn = "aerotow.uk";
    domains = [
      "bigfatrepack.org"
      "up1.uk"
      "to1.uk"
      "email.to1.uk"
      "nigel.to1.uk"
      "aeroplaying.uk"
      "amsl.consulting"
      "coaching.tvhgc.co.uk"
      "aerotow.uk"
      "9up.uk"
    ];
    forwards = {
      "info@aerotow.uk" =
        [ "aerotowrevival@gmail.com" "antsmithbxl@gmail.com" ];
      "steven@aerotow.uk" = [ "aerotowrevival@gmail.com" ];
      "tony@aerotow.uk" =
        [ "aerotowrevival@gmail.com" "antsmithbxl@gmail.com" ];
    };
    # A list of all login accounts. To create the password hashes, use
    # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
    loginAccounts = {
      "1@bigfatrepack.org" = {
        hashedPasswordFile =
          "/root/1@bigfatrepack.org"; # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt' > 1@bigfatrepack.org
        aliases = [ "@bigfatrepack.org" ];
        catchAll = [ "bigfatrepack.org" ];
      };
      "1@up1.uk" = {
        hashedPasswordFile =
          "/root/1@up1.uk"; # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt' > 1@up1.uk
        aliases = [ "@up1.uk" ];
        catchAll = [ "up1.uk" ];
      };
      "1@to1.uk" = {
        hashedPasswordFile =
          "/root/1@to1.uk"; # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt' > 1@to1.uk
        aliases = [ "@to1.uk" ];
        catchAll = [ "to1.uk" ];
      };
      "1@email.to1.uk" = {
        hashedPasswordFile =
          "/root/1@email.to1.uk"; # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt' > 1@email.to1.uk
        aliases = [
          "@email.to1.uk"
          "@nigel.to1.uk"
          "@coaching.tvhgc.co.uk"
          "@aerotow.uk"
          "@9up.uk"
        ];
        catchAll = [
          "email.to1.uk"
          "nigel.to1.uk"
          "coaching.tvhgc.co.uk"
          "aerotow.uk"
          "9up.uk"
        ];
      };
      "nigel@aeroplaying.uk" = {
        hashedPasswordFile =
          "/root/nigel@aeroplaying.uk"; # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt' > nigel@aeroplaying.uk
        aliases = [ "@aeroplaying.uk" "@amsl.consulting" ];
        catchAll = [ "aeroplaying.uk" "amsl.consulting" ];
      };

    };

    # Use Let's Encrypt certificates. Note that this needs to set up a stripped
    # down nginx and opens port 80.
    certificateScheme = "acme-nginx";
  };

  
  services.nginx = { # https://nixos.wiki/wiki/Nginx
    enable = true;
    virtualHosts = {
      "aeroplaying.uk" = {
        forceSSL = true;
        enableACME = true;
        root = "/var/www/aeroplaying.uk";
      }; # https://aeroplaying.uk https://ap.www.namecheap.com/Domains/DomainControlPanel/aeroplaying.uk/advancedns
      "G-CFRV.aeroplaying.uk" = {
        forceSSL = true;
        enableACME = true;
        root = "/var/www/aeroplaying.uk/G-CFRV";
      }; # https://aeroplaying.uk https://ap.www.namecheap.com/Domains/DomainControlPanel/aeroplaying.uk/advancedns
      "aerotow.uk" = {
        forceSSL = true;
        enableACME = true;
        root = "/var/www/aerotow.uk";
      }; # https://aerotow.uk lcn
      "amsl.consulting" = {
        forceSSL = true;
        enableACME = true;
        root = "/var/www/amsl.consulting";
      }; # https://amsl.consulting https://ap.www.namecheap.com/Domains/DomainControlPanel/amsl.consulting/advancedns
    };
  };
  
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
        IPForward = true;
      };
    };
  };

  users.users.git.group = "git";
  users.groups.git.members = [ "git" ] ;

  users.users.git = {
    isSystemUser = true;
    description = "git user";
    home = "/srv/local/git/";
    shell = "${pkgs.git}/bin/git-shell";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHGXa5qbZS3vXSkT4EcJDMp2IBOmeI0pu20wtHEiGb5A"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHbHmtDN6rrYtJoBtCce9jh6b4LHVuCzFqdpIzIEiCHI nrb@dubedary"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII62Xn7RMpaVkB820nigFuRWMBWh0uwheYKmvo28wSBy nrb@avingate"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIED/5na86b59uQF8cfsGAol7Sdutemrb3C5dA5+2sPS6 root@vps-df31287b"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILKifjn6NiNH06efGdhhfiPoT3uF15ueVevrFMY+hKXy root@vps-80d02460"
    ];
  };

  environment.systemPackages = with pkgs; [ wireguard-tools rsync git ];
}
