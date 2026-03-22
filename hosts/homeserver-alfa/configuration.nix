{
  config,
  pkgs,
  lib,
  ...
}:{
  imports = [
    ../../modules/base.nix
    ../../modules/auto-update.nix
    ./hardware-configuration.nix
  ];

  #Networking
  networking.hostName = "homeserver-alfa";
  networking.hostId = "00000001";

  # Set default password for the root user
  users.users.root.hashedPassword = "$6$ADWBv01H0c4VAOpm$jIKOp7G69UqoVzfccmxdH5BY/5aDaMktaubBkthj8cjA7Zo4YlaItUo93/LblsRoAqQYAZc2tnKHOW1CI1BGS1";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    btop
    neofetch
    ffmpeg
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  #users.users.plantuml = {
  #  isNormalUser = true;
  #  description = "plantuml";
  #  extraGroups = [ "networkmanager" "wheel" ];
  #  initialHashedPassword = "$6$ADWBv01H0c4VAOpm$jIKOp7G69UqoVzfccmxdH5BY/5aDaMktaubBkthj8cjA7Zo4YlaItUo93/LblsRoAqQYAZc2tnKHOW1CI1BGS1";
  #  #packages = with pkgs; [];
  #};

  # List services that you want to enable:

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 8080 ];
  # networking.firewall.allowedUDPPorts = [  ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  environment.variables = {
    PLANTUML_SECURITY_PROFILE = "INTERNET";
    PLANTUML_LIMIT_SIZE = 8192;
  };

  # DB (postgresql)
  services.postgresql = {
    enable = true;
    #ensureDatabases = [ "mydatabase" ];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
    '';
    dataDir = "/srv/postgresql";
  };


  #sops.nextcloud-adminpassfile = {
  #  owner = "nextcloud";
  #  group = "nextcloud";
  #};


  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud31;
    hostName = "cloud.innovativename.xyz";

    https = true;
    maxUploadSize = "16G";
    configureRedis = true;
    database.createLocally = true;
    # As recommended by admin panel
    phpOptions."opcache.interned_strings_buffer" = "24";

    # Instead of using pkgs.nextcloud28Packages.apps,
    # we'll reference the package version specified above
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps) news contacts calendar tasks;
    };
    extraAppsEnable = true;

    config = {
      adminuser = "ncp";
      adminpassFile = "aaa";
      dbtype = "pgsql";
    };

    settings = {
      defaultPhoneRegion = "DE";
      enabledPreviewProviders = [
        "OC\\Preview\\BMP"
        "OC\\Preview\\GIF"
        "OC\\Preview\\JPEG"
        "OC\\Preview\\Krita"
        "OC\\Preview\\MarkDown"
        "OC\\Preview\\MP3"
        "OC\\Preview\\OpenDocument"
        "OC\\Preview\\PNG"
        "OC\\Preview\\TXT"
        "OC\\Preview\\XBitmap"
        # Not included by default
        "OC\\Preview\\HEIC"
        "OC\\Preview\\Movie"
        "OC\\Preview\\MP4"
      ];
    };
  };
}
