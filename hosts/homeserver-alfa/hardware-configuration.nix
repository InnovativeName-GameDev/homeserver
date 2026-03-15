{ pkgs, ... }:
{
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda"; # Install GRUB to the disk
  boot.loader.grub.useOSProber = false;
  boot.loader.grub.zfsSupport = true;

  # Kernel modules for VirtualBox
  boot.kernelModules = [
    "vboxguest"
    "vboxsf"
    "vboxvideo"
  ];

  # add zfs support
  boot.supportedFilesystems = [ "zfs" ];

  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };
  fileSystems."/srv" = {
    device = "data";
    fsType = "zfs";
    options = [ "defaults" ];
  };

  # Limit zfs arc size (optimal would be 1 GB per TB but thats currently not possible) 
  # Set to 2 GiB
  # boot.kernelParams = [ "zfs.zfs_arc_max=2147483648" ];

  # zfs pools (data disk) setup
  boot.zfs.pools = {
    # Name of the pool
    data = { #if the disk structure changes please also change the activation script below
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
      #atime = false;            # don’t update access time (performance)
    };
  };
  # note: if the pool changes also update the activation script:
  system.activationScripts.createZfsPool = ''
    export PATH=$PATH:/run/current-system/sw/bin
    if ! zpool list data >/dev/null 2>&1; then
      echo "Creating ZFS pool data..."
      zpool create -f data /dev/sdb
      zfs set mountpoint=/srv data
      zfs set compression=lz4 data
      zfs set atime=off data
    fi
  '';
}
