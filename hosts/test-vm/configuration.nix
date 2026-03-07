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

  environment.systemPackages = with pkgs; [
    btop
  ];
}
