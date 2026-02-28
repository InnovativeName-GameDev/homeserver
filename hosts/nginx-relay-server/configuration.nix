{ config, pkgs, ... }:

{
  networking.hostName = "nginx-relay-server";

  services.nginx.virtualHosts."example2.com" = {
    root = "/var/www/example2";
    enableACME = true;
    forceSSL = true;
  };

  system.stateVersion = "24.05";
}