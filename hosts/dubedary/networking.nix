{ config, pkgs, lib, ... }: {
  networking.networkmanager.enable = false; #  You can not use networking.networkmanager with networking.wireless. Except if you mark some interfaces as <literal>unmanaged</literal> by NetworkManager.
}