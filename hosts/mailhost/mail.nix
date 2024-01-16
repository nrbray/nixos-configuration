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
  ];
  networking.domain = "to1.uk";
  networking.useNetworkd = true;
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
  security.acme.defaults.email = "security@mail.to1.uk";
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
}
