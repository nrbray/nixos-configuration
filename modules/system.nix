{ pkgs, lib, ... }: { # flakes clean-tmp-on-boot locale unfree select-pkgs root-sshd-certificate-only
  nix.settings.experimental-features = ["nix-command" "flakes"];
  boot.tmp.cleanOnBoot = true;
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "uk";
  };
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [ rsync git tmux ripgrep ];
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "prohibit-password";
  services.sshd.enable = true; # sshd is the OpenSSH server process
}