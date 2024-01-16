{ pkgs, lib, ... }: { 

  nix.settings.experimental-features = ["nix-command" "flakes"];

  boot.tmp.cleanOnBoot = true;
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "uk";
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [ rsync git tmux ripgrep ];
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "prohibit-password";
  services.sshd.enable = true;
}