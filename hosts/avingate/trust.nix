{ config, pkgs, ... }: { 
  users.users.nrb = {
    extraGroups = [ ]; 
    packages = with pkgs; [];
    # trust on this machine  
    openssh.authorizedKeys.keys = [ 
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHGXa5qbZS3vXSkT4EcJDMp2IBOmeI0pu20wtHEiGb5A NigelBray@gitlab.com" # nrb on ??
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKOFe/NHZ9mLV99iOV2eEMcApheSMXh1zQBjNwjr8dWC root@greatbar" # root on greatbar user on avingate 
    ]; };
  users.users.root.openssh.authorizedKeys.keys = [ 
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHGXa5qbZS3vXSkT4EcJDMp2IBOmeI0pu20wtHEiGb5A NigelBray@gitlab.com" ];  
}