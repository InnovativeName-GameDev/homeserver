### Set some default values for proxmox vms
{ pkgs, ... }:
{
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda"; # Install GRUB to the disk
  boot.loader.grub.useOSProber = false;

  #boot = {
  #  # Use the latest linux kernel
  #  kernelPackages = pkgs.linuxPackages_latest;
  #  # Grub bootloader stuff, no need to change this.
 #   loader = {
 #     efi.canTouchEfiVariables = true;
  #    grub = {
  #      enable = true;
  #      efiSupport = true;
  #      device = "nodev";
  #    };
  #  };
  #};

  # Minimal filesystem setup (root only)
  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };
  fileSystems."/srv" = {
    device = "/dev/sdb1";
    fsType = "ext4";
  };

  # Kernel modules for VirtualBox
  boot.kernelModules = [
    "vboxguest"
    "vboxsf"
    "vboxvideo"
  ];
}
