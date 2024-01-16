{ config, pkgs, ... }: { 
  users.users.nrb = {
    isNormalUser = true;
    packages = with pkgs; [];
    # minimum level of trust on most sensitive machine 
    openssh.authorizedKeys.keys = [ 
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHGXa5qbZS3vXSkT4EcJDMp2IBOmeI0pu20wtHEiGb5A" ];  
  };
}