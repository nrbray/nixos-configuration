{ config, pkgs, ... }: {
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
      "zobudz.uk" = {
        forceSSL = true;
        enableACME = true;
        root = "/var/www/aeroplaying.uk/zobudz";
      }; # https://admin.lcn.com/dns/mod.php?origin=zobudz.uk&ns=lcn.com
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
      "hghistory.to1.uk" = { forceSSL = true; enableACME = true; root = "/var/www/hghistory"; }; # https://to1.uk https://ap.www.namecheap.com/Domains/DomainControlPanel/to1.uk/advancedns
      "hghistory.aeroplaying.uk" = { forceSSL = true; enableACME = true; root = "/var/www/hghistory"; }; # https://to1.uk https://ap.www.namecheap.com/Domains/DomainControlPanel/to1.uk/advancedns
      "hghistory.aerotow.uk" = { forceSSL = true; enableACME = true; root = "/var/www/hghistory"; }; # https://to1.uk https://ap.www.namecheap.com/Domains/DomainControlPanel/to1.uk/advancedns
      "hghistory.9up.uk" = { forceSSL = true; enableACME = true; root = "/var/www/hghistory"; }; # https://to1.uk https://ap.www.namecheap.com/Domains/DomainControlPanel/to1.uk/advancedns
      "nigel.to1.uk" = { forceSSL = true; enableACME = true; root = "/var/www/aeroplaying.uk/Nigel"; }; # https://to1.uk https://ap.www.namecheap.com/Domains/DomainControlPanel/to1.uk/advancedns
    };
  };
}