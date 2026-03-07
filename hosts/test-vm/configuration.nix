{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [ ];

  # Enable QEMU Guest for Proxmox
  services.qemuGuest.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.availableKernelModules = [
    "virtio_pci"
    "virtio_scsi"
    "virtio_blk"
    "sd_mod"
  ];

  networking.hostName = "test-vm";
  networking.useDHCP = true;

  time.timeZone = "UTC";
  i18n.defaultLocale = "de.UTF-8";

  # Configure console keymap
  console.keyMap = "de";

  environment.systemPackages = with pkgs; [
    git
    curl
    qemu-guest-agent
  ];

  # Automatically
  boot.growPartition = true;

  # Default filesystem
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
    autoResize = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  system.stateVersion = "25.05";
}
