{ pkgs, ... }:

{
  # Enable flakes and nix-command experimental features system-wide
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.grub.enable = false;
  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    gnupg
    git
    sudo
  ];

  #fileSystems."/" = {
  #  device = "none";
  #  fsType = "tmpfs";
  #  # add the line below - limits root storage to 2G maximum
  #  options = [
  #    "defaults"
  #    "size=2G"
  #    "mode=755"
  #  ];
  #};

  # Update both /boot and /nix to use labels rather than UUID
  #fileSystems."/boot" = {
  #  device = "/dev/disk/by-label/boot";
  #  fsType = "ext4";
  #};

  #fileSystems."/nix" = {
  #  device = "/dev/disk/by-label/nix";
  #  fsType = "ext4";
  #};

  fileSystems."/boot/efi" = {
    device = "/dev/sda1";
    fsType = "vfat";
  };

  fileSystems."/" = {
    device = "/dev/sda2";
    fsType = "ext4";
  };


  # Include encrypted SSH key in ISO
  environment.etc."secrets/nixos_deploy_key".source = ../secrets/nixos_deploy_key;
  environment.etc."secrets/nixos_deploy_key".mode = "0600";

  # Copy install script into the live user's home
  environment.etc."install.sh".source = ./install.sh;
  environment.etc."install.sh".mode = "0755";

  # Optional: run some setup script on ISO boot
  #programs.bash.loginShellInit = ''
  #  if [ -z "$INSTALLER_RAN" ]; then
  #    export INSTALLER_RAN=1
  #    echo "Booted live ISO!!"
  #    echo "Welcome to the installer!"
  #    read -p "Press ENTER to start installation..."
  #    sudo /etc/install.sh
  #  fi
  #'';
  programs.bash.loginShellInit = ''
    if [ -z "$INSTALLER_RAN" ]; then
      export INSTALLER_RAN=1
      echo "Booted live ISO!!"
      echo "Welcome to the installer!"

      # Ensure tmp is disk-based
      mkdir -p /mnt/tmp
      export TMPDIR=/mnt/tmp
      export NIX_REMOTE_TMPDIR=/mnt/tmp

      read -p "Press ENTER to start installation..."
      sudo /etc/install.sh
    fi
  '';
}
