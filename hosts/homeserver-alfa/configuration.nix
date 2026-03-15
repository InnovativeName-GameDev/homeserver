{ pkgs, ... }:
{
  # Enable flakes and nix-command
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  #Networking
  networking = {
    hostName = "homeserver-alfa";
    networkmanager = {
      enable = true;
    };
  };

  #configure autoUpgrade!
  system.autoUpgrade = {
    enable = true;
    flake = "github:InnovativeName-GameDev/homeserver#homeserver-alfa";
    flags = [
      "-L" # print build logs
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };


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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    btop
    neofetch
  ];

  nixpkgs.config.allowUnfree = true;

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
    PLANTUML_SECURITY_PROFILE="INTERNET";
    PLANTUML_LIMIT_SIZE=8192;
  };

}
