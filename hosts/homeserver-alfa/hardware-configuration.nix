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
  virtualisation.virtualbox.guest.enable = true;

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
  boot.kernelParams = [ "zfs.zfs_arc_max=2147483648" ]; # Set to 2 GiB

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
