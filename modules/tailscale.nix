{ ... }:

{
  services.tailscale.enable = true;

  networking.nameservers = [ "100.100.100.100" "1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4"];
  networking.search = [ "example.ts.net" ];
}