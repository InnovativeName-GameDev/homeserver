### Set some default values for proxmox vms
{
  config,
  ...
}:
{
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

  # Enable automatic Updates
  system.autoUpgrade = {
    enable = true;
    flags = [
      "-L" # print build logs
    ];
    dates = "2min";
  };
  assertions = [
    {
      assertion = !config.system.autoUpgrade.enable || config.system.autoUpgrade.flake != null;
      message = "Host must set system.autoUpgrade.flake when autoUpgrade is enabled";
    }
  ];

  # Enable flakes and nix-command
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Enable password feedback for sudo
  security.sudo.extraConfig = "Defaults pwfeedback";

  # Set State Version to the same version everywhere.
  system.stateVersion = "25.11";

  # Nix build configuration for low-RAM VM
  nix.settings.max-jobs = 1; # build one derivation at a time
  nix.settings.cores = 1; # build one core at a time
  
  # Do memory compression
  zramSwap.enable = true;
  #swapDevices = [
  #  { device = "/swapfile"; size = 1024; }
  #];

  # Enable networking
  networking.wireless.enable = false;
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Configure console keymap and Locate
  console.keyMap = "de";

  # Enable QEMU Guest for Proxmox
  services.qemuGuest.enable = true;

  # Set default password for the root user
  users.users.root.hashedPassword = "$6$ADWBv01H0c4VAOpm$jIKOp7G69UqoVzfccmxdH5BY/5aDaMktaubBkthj8cjA7Zo4YlaItUo93/LblsRoAqQYAZc2tnKHOW1CI1BGS1";

  # Disable Unneeded Services
  services.xserver.enable = false;

}
