{ config, pkgs, ... }: { 
  users.users.nrb = {
    extraGroups = [  "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [ 
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHGXa5qbZS3vXSkT4EcJDMp2IBOmeI0pu20wtHEiGb5A NigelBray@gitlab.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHbHmtDN6rrYtJoBtCce9jh6b4LHVuCzFqdpIzIEiCHI nrb@dubedary"
      ];  
  };
  users.users.root.openssh.authorizedKeys.keys = [ 
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHGXa5qbZS3vXSkT4EcJDMp2IBOmeI0pu20wtHEiGb5A NigelBray@gitlab.com" 
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHbHmtDN6rrYtJoBtCce9jh6b4LHVuCzFqdpIzIEiCHI nrb@dubedary"
    ];  
}
