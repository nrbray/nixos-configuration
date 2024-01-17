{ pkgs, lib, ... }: { # flakes clean-tmp-on-boot locale unfree select-pkgs root-sshd-certificate-only
  nix.settings.experimental-features = ["nix-command" "flakes"];
  boot.tmp.cleanOnBoot = true;
  time.timeZone = "Europe/London";  # Set your time zone.
  i18n.defaultLocale = "en_GB.UTF-8";  # Select internationalisation properties.
  console = { font = "Lat2-Terminus16"; keyMap = "uk"; };  # Configure console keymap
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [ rage rsync git tmux ripgrep kalker ];
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.PermitRootLogin = "prohibit-password";
    settings.challengeResponseAuthentication = false;
    allowSFTP = false; 
    extraConfig = ''
      AllowTcpForwarding yes
      X11Forwarding no
      AllowAgentForwarding no
      AllowStreamLocalForwarding no
      AuthenticationMethods publickey
      '';
  };
  services.sshd.enable = true; # sshd is the OpenSSH server process
}