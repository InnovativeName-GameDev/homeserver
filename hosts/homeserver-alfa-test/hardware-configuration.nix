### Set some default values for proxmox vms
{ pkgs, ... }:
{
  # Minimal system
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda"; # Install GRUB to the disk
  boot.loader.grub.useOSProber = false;

  # Don't bother with EFI for a basic VirtualBox VM
  boot.loader.efi.canTouchEfiVariables = false;

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
