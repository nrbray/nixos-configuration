{ config, pkgs, ... }: { 
  users.mutableUsers = true; # https://nixos.org/manual/nixos/stable/options#opt-users.mutableUsers Warning If set to false, the contents of the user and group files will simply be replaced on system activation. This also holds for the user passwords; all changed passwords will be reset according to the users.users configuration on activation.
  users.users.root.hashedPassword = "!"; # should document more clearly: nothing can possibly hash to just “!”, so it effectively disables password auth for the root user. hashedPassword overrides both password and hashedPasswordFile
  users.groups.nrb.members = [ "nrb" ];
  users.users.nrb = {
    description = "Nigel Bray";
    isNormalUser = true;
    group = "nrb";
    hashedPassword = "$y$j9T$lOA2eMKaKIjSfkoBEvOuP.$aXCkjUagrnwBkf0GcWCmlQ8l2HF7psYEsi27lZitZP/"; #  The initial password for a user will be set according to users.users, but existing passwords will not be changed. hashedPassword overrides both password and hashedPasswordFile
    # minimum level of trust on most sensitive machine 
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHGXa5qbZS3vXSkT4EcJDMp2IBOmeI0pu20wtHEiGb5A NigelBray@gitlab.com" ];  
  };
}