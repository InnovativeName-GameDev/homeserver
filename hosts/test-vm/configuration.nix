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

  #Network
  networking.hostName = "pve-test-vm";
  networking.useDHCP = true;

  environment.systemPackages = with pkgs; [
    btop
  ];

  system.stateVersion = "25.05";
}
