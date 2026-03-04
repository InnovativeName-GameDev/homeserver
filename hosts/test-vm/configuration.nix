{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.device = "nodev"; # UEFI uses ESP

  boot.initrd.availableKernelModules = [
    "virtio_pci" "virtio_scsi" "virtio_blk" "sd_mod" "sr_mod"
  ];

  networking.hostName = "nginx-homeserver";
  networking.useDHCP = true;

  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [ vim git curl ];
}