{ config, pkgs, ... }:

{
  networking.hostName = "relay-server";

  #configure autoUpgrade!
  system.autoUpgrade.flake = "github:InnovativeName-GameDev/homeserver#relay-server";


  services.nginx.virtualHosts."example2.com" = {
    root = "/var/www/example2";
    enableACME = true;
    forceSSL = true;
  };

  system.stateVersion = "24.05";
}