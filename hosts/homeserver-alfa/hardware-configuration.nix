{ pkgs, ... }:
{
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda"; # Install GRUB to the disk
  boot.loader.grub.useOSProber = false;
  boot.loader.grub.zfsSupport = true;

  boot.supportedFilesystems = [ "zfs" ];

  # Minimal filesystem setup (root only)
  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };

  # Limit zfs arc size (optimal would be 1 GB per TB but thats currently not possible) 
  # Set to 2 GiB
  # boot.kernelParams = [ "zfs.zfs_arc_max=2147483648" ];

  boot.zfs.pools = {
    # Name of the pool
    data = {
      # For a single-disk pool:
      devices = [ "/dev/sdb" ];

      # For a RAID1 mirror:
      # devices = [{ type = "mirror"; devices = [ "/dev/sdb" "/dev/sdc" ]; }];

      # For RAID10 (mirrored pairs):
      #devices = [
      #  { type = "mirror"; devices = [ "/dev/sdb" "/dev/sdc" ]; }
      #  { type = "mirror"; devices = [ "/dev/sdd" "/dev/sde" ]; }
      #];

      # Pool properties
      mountpoint = "/srv";      # where to mount the pool
      autoScrub.enable = true;  # automatic scrub
      compression = "lz4";      # fast compression
      atime = false;            # don’t update access time (performance)
    };
  };

  # Kernel modules for VirtualBox
  boot.kernelModules = [
    "vboxguest"
    "vboxsf"
    "vboxvideo"
  ];
}
