{ config, pkgs, ... }:

{
  # Enable flakes and nix-command experimental features system-wide
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.grub.enable = false;
  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    gnupg
    git
  ];

  # Include encrypted SSH key in ISO
  environment.etc."ssh/id_ed25519.gpg".source = ./encrypted/nixos-deploy-key.gpg;
}