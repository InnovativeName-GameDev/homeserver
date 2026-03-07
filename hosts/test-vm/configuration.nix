{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ../../modules/pve-base.nix
  ];

  system.autoUpgrade.flake = "github:InnovativeName-GameDev/homeserver#test-vm";

  #Network
  networking.hostName = "pve-test-vm";

  environment.systemPackages = with pkgs; [
    btop
  ];
}
