{ config, pkgs, lib, ... }:

{
  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" ];
  boot.kernelModules = [];

  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/boot/efi" = {
    device = "/dev/sda1";
    fsType = "vfat";
  };

  fileSystems."/" = {
    device = "/dev/sda2";
    fsType = "ext4";
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}