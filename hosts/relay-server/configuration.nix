{ ... }:

{
  imports = [
    ../../modules/pve-base.nix
    ../../modules/tailscale.nix
    ./nginx.nix
  ];

  networking.hostName = "relay-server";

  #configure autoUpgrade!
  system.autoUpgrade.flake = "github:InnovativeName-GameDev/homeserver#relay-server";


  services.nginx.virtualHosts."example2.com" = {
    root = "/var/www/example2";
    enableACME = true;
    forceSSL = true;
  };
}