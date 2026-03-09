### Set some default values for proxmox vms
{ pkgs, ... }:
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
  #boot.growPartition = true;

  # filesystem
  #fileSystems."/" = {
  #  device = "/dev/disk/by-label/nixos";
  #  fsType = "ext4";
  #  autoResize = true;
  #};
  #fileSystems."/boot" = {
  #  device = "/dev/disk/by-label/boot";
  #  fsType = "vfat";
  #};

  # Enable flakes and nix-command
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Enable password feedback for sudo
  security.sudo.extraConfig = "Defaults pwfeedback";

  # Set State Version to the same version everywhere.
  system.stateVersion = "25.11";

  # Enable networking
  networking.wireless.enable = false;
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

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

  # Set default password for the root user
  users.users.root.hashedPassword = "$6$ADWBv01H0c4VAOpm$jIKOp7G69UqoVzfccmxdH5BY/5aDaMktaubBkthj8cjA7Zo4YlaItUo93/LblsRoAqQYAZc2tnKHOW1CI1BGS1";

  environment.systemPackages = with pkgs; [
    btop
    neofetch
    nginx
    nextcloud31
    paperless-ngx
    plantuml
    plantuml-server
    jenkins
    jellyfin
    ollama
    suwayomi-server
  ];

    # Generate a random password at boot if it doesn't exist
  systemd.services.generate-nextcloud-admin-pass = {
    description = "Generate Nextcloud admin password (test)";
    wantedBy = [ "multi-user.target" ];
    before = [ "nextcloud-setup.service" ];
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
    script = ''
      install -m 0700 -d /run/secrets
      if [ ! -f /run/secrets/nextcloud-admin-pass ]; then
        ${pkgs.openssl}/bin/openssl rand -base64 24 > /run/secrets/nextcloud-admin-pass
        chmod 600 /run/secrets/nextcloud-admin-pass
      fi
    '';
  };

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud31;
    hostName = "cloud.innovativename.xyz";
    datadir = "/srv/nextcloud";

    config = {
      adminuser = "admin";
      adminpassFile = "/run/secrets/nextcloud-admin-pass";

      dbtype = "pgsql";
      dbuser = "nextcloud";
      dbhost = "/run/postgresql";
      dbname = "nextcloud";
    };
    settings = {
      trusted_domains = [ "cloud.innovativename.xyz" ];
      trusted_proxies = [ "127.0.0.1" ];
      overwriteprotocol = "https";
    };

    https = true;
    enableImagemagick = true;

    phpOptions = {
      "opcache.interned_strings_buffer" = "16";
      "opcache.max_accelerated_files" = "10000";
      "opcache.memory_consumption" = "128";
      "opcache.revalidate_freq" = "1";
      "opcache.fast_shutdown" = "1";
    };
  };

  services.nginx = {
    enable = true;

    # Don't listen on port 80 - only localhost
    defaultHTTPListenPort = 8080;
    defaultListenAddresses = [ "127.0.0.1" ];

    # Disable the default virtual host
    virtualHosts = {
      "cloud.innovativename.xyz" = {
        listen = [
          {
            addr = "127.0.0.1";
            port = 8080;
          }
        ];
      };
    };
  };

  virtualisation.docker = {
    enable = true;
  };

  services.jellyfin = {
    enable = true;
    openFirewall = false;
    user = "media";
    group = "media";
    dataDir = "/srv/jellyfin";
  };

  users.users.media = {
    isSystemUser = true;
    group = "media";
    createHome = false;
  };
  users.groups.media = { };

  services.paperless = {
    enable = true;
    address = "127.0.0.1";
    port = 28981;

    dataDir = "/srv/paperless";
    mediaDir = "/srv/paperless/media";
    consumptionDir = "/srv/paperless/consume";

    settings = {
      PAPERLESS_OCR_LANGUAGE = "eng";
      PAPERLESS_TIME_ZONE = "Europe/Amsterdam";
      PAPERLESS_ADMIN_USER = "meow";
      PAPERLESS_DBHOST = "/run/postgresql";
      PAPERLESS_DBNAME = "paperless";
      PAPERLESS_DBUSER = "paperless";
      PAPERLESS_URL = "https://paperless.innovativename.xyz";
    };
  };

  # Centralized PostgreSQL instance for all services
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;

    extraPlugins = with pkgs.postgresql16Packages; [
      pgvector
    ];

    # Store database on shared disk
    dataDir = "/srv/postgresql/16";

    # Enable extensions
    enableTCPIP = true;

    settings = {
      max_connections = 200;
      shared_buffers = "256MB";
      effective_cache_size = "1GB";
      maintenance_work_mem = "64MB";
      checkpoint_completion_target = 0.9;
      wal_buffers = "16MB";
      default_statistics_target = 100;
      random_page_cost = 1.1;
      effective_io_concurrency = 200;
      work_mem = "2621kB";
      min_wal_size = "1GB";
      max_wal_size = "4GB";
    };

    # Create databases and users for all services
    ensureDatabases = [
      "authentik"
      "immich"
      "nextcloud"
      "paperless"
    ];

    ensureUsers = [
      {
        name = "authentik";
        ensureDBOwnership = true;
      }
      {
        name = "immich";
        ensureDBOwnership = true;
      }
      {
        name = "nextcloud";
        ensureDBOwnership = true;
      }
      {
        name = "paperless";
        ensureDBOwnership = true;
      }
    ];

    authentication = pkgs.lib.mkOverride 10 ''
      # Allow local connections
      local all all trust
      host all all 127.0.0.1/32 trust
      host all all ::1/128 trust
      # Allow Docker network
      host all all 172.17.0.0/16 trust
    '';
  };

  # pgAdmin for database management
  services.pgadmin = {
    enable = true;
    initialEmail = "ds";

    settings = {
      PGADMIN_LISTEN_ADDRESS = "127.0.0.1";
      PGADMIN_LISTEN_PORT = 5050;
    };
  };

  # Redis for caching (shared by multiple services)
  services.redis.servers.shared = {
    enable = true;
    port = 6379;
    # Bind to all interfaces to allow Docker container access regardless of network mode
    # Security: openFirewall=false ensures port 6379 is blocked by the firewall
    # Only accessible from localhost and Docker containers, not from external networks
    # This works with both bridge networking (host.docker.internal) and host networking
    bind = null; # null = bind to 0.0.0.0 (all interfaces)
    # Don't open firewall - only accessible locally and from Docker
    openFirewall = false;

    # Disable protected mode to allow Docker container connections
    # Protected mode blocks non-localhost connections when no password is set
    # This is safe because:
    # - Firewall blocks external access (openFirewall = false)
    # - Redis only accessible from localhost and Docker containers
    # - No internet exposure
    # - Standard approach for containerized environments with firewall protection
    settings = {
      protected-mode = "no";
    };
  };
}
