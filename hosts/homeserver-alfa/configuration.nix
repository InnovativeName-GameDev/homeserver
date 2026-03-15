### Set some default values for proxmox vms
{ pkgs, ... }:
{
  # Minimal system
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda"; # Install GRUB to the disk
  boot.loader.grub.useOSProber = false;

  # Don't bother with EFI for a basic VirtualBox VM
  boot.loader.efi.canTouchEfiVariables = false;

  # Minimal filesystem setup (root only)
  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };

  # Kernel modules for VirtualBox
  boot.kernelModules = [
    "vboxguest"
    "vboxsf"
    "vboxvideo"
  ];

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable flakes and nix-command
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Enable password feedback for sudo
  security.sudo.extraConfig = "Defaults pwfeedback";

  # Set State Version to the same version everywhere.
  system.stateVersion = "25.05";

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
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "mongodb-7.0.25"
    "python3.12-youtube-dl-2021.12.17"
  ];

  nixpkgs.config.allowUnfree = true;

  # Lightweight HTTP servers
  services.nginx.enable = true;
  services.plantuml-server.enable = true;
  services.suwayomi-server.enable = true;

  # Monitoring / dashboards (default config works)
  services.prometheus.enable = true;
  services.grafana.enable = true;

  # Other fun or small servers
  services.dnsmasq.enable = true;
  services.cron.enable = true;
  services.rsyncd.enable = true;

  #services.apacheHttpd.enable = true;
  services.postgresql.enable = true;
  services.redis.servers.shared.enable = true;
  services.mongodb.enable = true;
  services.rabbitmq.enable = true;
  services.jenkins.enable = true;
  #services.docker.enable = true;
  #services.podman.enable = true;
  #services.nextcloud.enable = true;
  #services.paperless.enable = true;
  #services.jellyfin.enable = true;
  services.immich.enable = true;
  #services.authentik.enable = true;
  services.minio.enable = true;
  services.syncthing.enable = true;
  #services.keycloak.enable = true;
  services.tailscale.enable = true;
  services.minecraft-server.enable = true;
  services.minecraft-server.eula = true;

  # 1️⃣ Nextcloud (pulls PHP, databases, image libraries)
  services.nextcloud = {
    enable = true;
    hostName = "cloud.test.local";
    https = false; # no SSL for quick test

    config = {
      adminuser = "admin";
      adminpassFile = "/run/secrets/test-nextcloud-pass";
      dbtype = "sqlite"; # simplest for test
      dbname = "nextcloud";
    };
  };

  # 2️⃣ Paperless-ngx (Python heavy, pulls OCR)
  services.paperless = {
    enable = true;
    address = "127.0.0.1";
    port = 28981;

    dataDir = "/srv/paperless";
    mediaDir = "/srv/paperless/media";
    consumptionDir = "/srv/paperless/consume";

    settings = {
      PAPERLESS_OCR_LANGUAGE = "eng";
      PAPERLESS_TIME_ZONE = "Europe/Berlin";
      PAPERLESS_ADMIN_USER = "test";
      PAPERLESS_DBTYPE = "sqlite";
    };
  };

  # 3️⃣ Jellyfin (media server, pulls ffmpeg and lots of codecs)
  services.jellyfin = {
    enable = true;
    user = "media";
    group = "media";
    dataDir = "/srv/jellyfin";
    openFirewall = false;
  };

  users.users.media = {
    isSystemUser = true;
    group = "media";
    createHome = false;
  };
  users.groups.media = { };

  # --- Optional: auto-generate test passwords ---
  systemd.services.generate-test-passwords = {
    description = "Generate test passwords for services";
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
    serviceConfig.ExecStart = ''
      install -d -m 0700 /run/secrets
      echo "testpassword" > /run/secrets/test-nextcloud-pass
      chmod 600 /run/secrets/test-nextcloud-pass
    '';
  };

  virtualisation.docker = {
    enable = true;
  };

  virtualisation.oci-containers.containers = {
    #open-webui = {
    #  image = "ghcr.io/open-webui/open-webui:v0.4.5"; # Pinned to stable version
    #  ports = [ "3000:8080" ];
    #  extraOptions = [ "--add-host=host.docker.internal:host-gateway" ];
    #};

    #searxng = {
    #  image = "searxng/searxng:latest";
    #  ports = [ "8888:8080" ];
    #};
  };

  services.ollama = {
    enable = true;
    openFirewall = false;
    host = "127.0.0.1";
    port = 11434;
  };

  virtualisation.oci-containers.containers = {
    immich-server = {
      image = "ghcr.io/immich-app/immich-server:release";
      extraOptions = [ "--network=host" ];
    };

    immich-machine-learning = {
      image = "ghcr.io/immich-app/immich-machine-learning:release";
    };
  };

  nixpkgs.overlays = [
    (final: prev: {
      paperless-ngx = prev.paperless-ngx.overrideAttrs (_: {
        doCheck = false;
        checkPhase = "true";
      });
    })
  ];

}
