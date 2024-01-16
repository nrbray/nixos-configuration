# scp ./NixOS/57.128.170.244/configuration.nix root@57.128.170.244:/etc/nixos/configuration.nix; git add ./NixOS/57.128.170.244/configuration.nix; `which ssh` root@57.128.170.244 -- nixos-rebuild switch; `which ssh` nrb@57.128.170.244
# clone from file:///./../servmail/configuration.nix

{ config, pkgs, lib, ... }:

{
  imports = [
    (builtins.fetchTarball {
      # Pick a release version you are interested in and set its hash, e.g.
      url =
        "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/nixos-23.11/nixos-mailserver-nixos-23.11.tar.gz";
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

  environment.defaultPackages = lib.mkForce [ ];

  boot.tmp.cleanOnBoot = true;
  system.stateVersion = "23.11";
  zramSwap.enable = true;
  networking.hostName = "mailhost";
  networking.domain = "to1.uk";
  networking.useNetworkd = true;
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "prohibit-password";
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDqsazlhOhBl2bmUbvnsLLYeuLBfVrLsfOt5nv3FKw9Nui1y7PmiTacU+CEDex3gLAA6KLP8a+o4uPH1y16L/ZJhADqc6cuYcnFIyMWgsO2TfFz5SUmsgSFN3FUZuJ1aMdp+hz0o2pUZIwKVAy/LwvPzvWmTlcgyQOBMWKqD/lm+KKSAV87OcnRhdhDj2/36QxDVI+5dG5yQJ0xR7mcmUxADEtrkH1ONM7a4M+or9T7285+zlXwsxkGDTKHCULHx0gfaUP5Xph4WfHFcmbKWZ+RygUWYHC/I8xHfvP4EFvPIZfv8jppysDx9sLpMsUiLylbkJ298L+Grq/H6QYc/QZG6LDF0dzqgxpAzKWjOeYBiUZ2HQ9nHNDZiWsQb6+Ai8MnRC0irPXFvYkMooNj+9JEZ5LXnm7WA4/Z99wz0Ucd3cYTazpB+H+BkK07wdecsXIC0C/bTsVo4wUSGkrezRv6Im6Mxp4Ag90FDaW3d0OmOQhiXaMsoa1p3LhT+F1zY+c= nrb@nixos"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDf+wIUgLHwwb19+b8siWPnQMiHSA0Vj/C8jGVvCWUa2 root@vps-6ec22220"
  ];

  mailserver = {
    enable = true;
    fqdn = "mail.to1.uk";
    # to set up domains MX record + SPF record + DKIM signature + DMARC record + reverse DNS
    domains = [
      "bigfatrepack.org"
      "up1.uk"
      "to1.uk"
      "email.to1.uk"
      "nigel.to1.uk"
      "aeroplaying.uk"
      "amsl.consulting"
      "coaching.tvhgc.co.uk"
      "aerotow.uk" # https://ap.www.namecheap.com/Domains/DomainControlPanel/aerotow.uk/advancedns 
      "9up.uk"
    ];
    forwards = {
      "info@aerotow.uk" =
        [ "aerotowrevival@gmail.com" "antsmithbxl@gmail.com" "nigel@aeroplaying.uk" ];
      "steven@aerotow.uk" = [ "aerotowrevival@gmail.com" ];
      "tony@aerotow.uk" = [ "antsmithbxl@gmail.com" ];
      "ac@to1.uk" = [ "ac.camborne@gmail.com" ];
      "POCRUISES2@EMAIL.TO1.UK" = [ "ac.camborne@gmail.com" "pocruises.CABIN1@EMAIL.TO1.UK" ];
      "POCRUISES2.CABIN2@EMAIL.TO1.UK" = [ "ac.camborne@gmail.com" "pocruises.CABIN2@EMAIL.TO1.UK" ];
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
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "security@bigfatrepack.org";

  networking.firewall.allowedTCPPorts = [ 443 ];

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
      "to1.uk" = {
        forceSSL = true;
        enableACME = true;
        root = "/var/www/to1.uk/public";
      }; # https://to1.uk https://ap.www.namecheap.com/Domains/DomainControlPanel/to1.uk/advancedns
    };
  };
  environment.systemPackages = with pkgs; [ wireguard-tools rsync git ];
}
