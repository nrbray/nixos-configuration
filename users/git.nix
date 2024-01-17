{ config, pkgs, ... }: { 
  users.users.git.group = "git";
  users.groups.git.members = [ "git" "nrb" ] ;
  users.users.git = {
    isSystemUser = true;
    description = "git user";
    home = "/srv/local/git/";
    shell = "${pkgs.git}/bin/git-shell";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKOFe/NHZ9mLV99iOV2eEMcApheSMXh1zQBjNwjr8dWC root@greatbar"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHGXa5qbZS3vXSkT4EcJDMp2IBOmeI0pu20wtHEiGb5A"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHbHmtDN6rrYtJoBtCce9jh6b4LHVuCzFqdpIzIEiCHI nrb@dubedary"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII62Xn7RMpaVkB820nigFuRWMBWh0uwheYKmvo28wSBy nrb@avingate"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIED/5na86b59uQF8cfsGAol7Sdutemrb3C5dA5+2sPS6 root@vps-df31287b"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILKifjn6NiNH06efGdhhfiPoT3uF15ueVevrFMY+hKXy root@vps-80d02460"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAysC3LxSbpg3NcUQDepWWwIVANKKTz/CNBvw/G0OGLL root@mailhost"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIsIPH42lj/lj6MAdr8hyKWdBA+fpPTxPmxdD9lxkvJ6 root@dubedary"
    ];
  };
}