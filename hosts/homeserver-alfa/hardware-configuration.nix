### Set some default values for proxmox vms
{ pkgs, ... }:
{
  boot = {
    # Use the latest linux kernel
    kernelPackages = pkgs.linuxPackages_latest;
    # Grub bootloader stuff, no need to change this.
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
      };
    };
  };

  # Minimal filesystem setup (root only)
  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };

  # Kernel modules for VirtualBox
  boot.kernelModules = [
    "vboxguest"
    "vboxsf"
    "vboxvideo"
  ];
}
