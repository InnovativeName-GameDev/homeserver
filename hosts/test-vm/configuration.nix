{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [ ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Kernal Modules
  boot.initrd.availableKernelModules = [
    "virtio_pci"
    "virtio_scsi"
    "virtio_blk"
    "sd_mod"
  ];

  # Automatically grow partitions if disks increase thier size
  boot.growPartition = true;

  # filesystem
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
    autoResize = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  #Network
  networking.hostName = "test-vm";
  networking.useDHCP = true;

  # Usability
  time.timeZone = "UTC";
  i18n.defaultLocale = "de_DE.UTF-8";

  # Configure console keymap
  console.keyMap = "de";

  environment.systemPackages = with pkgs; [
    git
    curl
  ];

  # Enable QEMU Guest for Proxmox
  services.qemuGuest.enable = true;

  # User Managment
  users.users.root.hashedPassword = "$6$ADWBv01H0c4VAOpm$jIKOp7G69UqoVzfccmxdH5BY/5aDaMktaubBkthj8cjA7Zo4YlaItUo93/LblsRoAqQYAZc2tnKHOW1CI1BGS1";

  system.stateVersion = "25.05";
}
