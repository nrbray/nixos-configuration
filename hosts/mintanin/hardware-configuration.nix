# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/737de350-23bf-469a-92e5-2acfe09f92ff";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

  boot.initrd.luks.devices."luks-13c9ffc1-92e0-4041-b463-3113acabab31".device = "/dev/disk/by-uuid/13c9ffc1-92e0-4041-b463-3113acabab31";

  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/F98C-BDAC";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/4ede5568-fb87-4354-8cc6-03b214caabfc"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s20f0u3u2.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp4s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # high-resolution display
/*   hardware.video.hidpi.enable = lib.mkDefault true;
  error:
       Failed assertions:
       - The option definition `hardware.video.hidpi.enable' in `/nix/store/b1vg15070i3i85vh3fqyii30y1hyi9n5-source/NixOS/mintanin/gnome/hardware-configuration.nix' no longer has any effect; please remove it.
       Consider manually configuring fonts.fontconfig according to personal preference.
(use '--show-trace' to show detailed location information) */
}
