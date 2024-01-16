{ config, pkgs, ... }: { 
  users.users.nrb = {
    packages = with pkgs; [];
    # trust on this machine  
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHGXa5qbZS3vXSkT4EcJDMp2IBOmeI0pu20wtHEiGb5A" ];  
  };
  users.users.root.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHGXa5qbZS3vXSkT4EcJDMp2IBOmeI0pu20wtHEiGb5A" ];  
}