### Set some default values for proxmox vms
{ pkgs, ... }:
{
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda"; # Install GRUB to the disk
  boot.loader.grub.useOSProber = false;
  boot.loader.grub.zfsSupport = true;


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

  #zfs pool for service data
  boot.supportedFilesystems = [ "zfs" ];

  #limit zfs arc size (optimal would be 1 GB per TB but thats currently not possible)
  boot.kernelParams = [ "zfs.zfs_arc_max=2147483648" ];

  boot.zfs.pools."data" = {
    # specify the vdevs
    # start with a single disk, can expand later
    devices = [ "/dev/sdb" ];
    mountpoint = "/srv";  # mount directly
    # optional settings
    autoScrub.enable = true;
    compression = "lz4";
    atime = false;
  };

  # Kernel modules for VirtualBox
  boot.kernelModules = [
    "vboxguest"
    "vboxsf"
    "vboxvideo"
  ];
}
