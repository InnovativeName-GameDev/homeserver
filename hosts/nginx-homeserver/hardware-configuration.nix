{ config, pkgs, lib, ... }:

{
  # Kernel modules for generic VM
  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" ];
  boot.kernelModules = [];

  # Root filesystem
  fileSystems."/" = {
    device = "/dev/sda1";  # generic device path
    fsType = "ext4";
    options = [ "noatime" ];
  };

  # Swap
  swapDevices = [
    { device = "/dev/sda2"; }
  ];

  # Minimal host platform
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}