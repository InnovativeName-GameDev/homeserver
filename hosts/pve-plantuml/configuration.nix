# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  imports = [
    ../../modules/pve-base.nix
    ../../modules/tailscale.nix
    ./nginx.nix
  ];

  #configure autoUpgrade!
  system.autoUpgrade.flake = "github:InnovativeName-GameDev/homeserver#pve-plantuml";

  networking.hostName = "pve-plantuml"; # Define your hostname.

  #networking
  networking = {
    interfaces.ens18 = {
      ipv4.addresses = [
        {
          address = "192.168.178.250";
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = {
      address = "192.168.178.1";
      interface = "ens18";
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.plantuml = {
    isNormalUser = true;
    description = "plantuml";
    extraGroups = [ "networkmanager" "wheel" ];
    #packages = with pkgs; [];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    plantuml
  ];

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
