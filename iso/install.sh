#!/usr/bin/env bash
set -e

DEPLOY_KEY=/root/.ssh/id_ed25519
FLAKE_DIR=/mnt/root/flake
DEFAULT_FLAKE="nginx-homeserver"

mkdir -p /root/.ssh

# Create legacy boot partition of 512MB
parted /dev/sda -- mklabel msdos
parted /dev/sda -- mkpart primary ext4 1M 512M
parted /dev/sda -- set 1 boot on

# Create root partition on remaining storage
parted /dev/sda -- mkpart primary ext4 512MiB 100%

# Label both partitions
mkfs.ext4 -L boot /dev/sda1
mkfs.ext4 -L nix /dev/sda2

# Create root mount with tmpfs
mount -t tmpfs none /mnt

# Create folder structure to persist in /nix/persist - srv is optional, used as home directory for services
mkdir -p /mnt/{boot,nix,etc/{nixos,ssh},var/{lib,log},srv}

# Mount relevant partitions to each folder
mount /dev/sda1 /mnt/boot
mount /dev/sda2 /mnt/nix

# Create matching folders in /mnt/nix/persist
mkdir -p /mnt/nix/persist/{etc/{nixos,ssh},var/{lib,log},srv}

# Create temporary bind mounts (later replaced with impermanence - refer to post linked above)
mount -o bind /mnt/nix/persist/etc/nixos /mnt/etc/nixos
mount -o bind /mnt/nix/persist/var/log /mnt/var/log

#sudo mkdir -p /mnt/nix/var/nix
#sudo chown -R root:root /mnt
#sudo chmod -R 755 /mnt

if [ ! -f "$DEPLOY_KEY" ]; then
  cp /etc/secrets/nixos_deploy_key "$DEPLOY_KEY"
  chmod 600 "$DEPLOY_KEY"
fi

if [ ! -d "$FLAKE_DIR" ]; then
  echo "Cloning flake..."
  git clone git@github.com:InnovativeName-GameDev/homeserver.git "$FLAKE_DIR"
fi

echo "Building default flake: $DEFAULT_FLAKE"
nixos-install --flake "$FLAKE_DIR#$DEFAULT_FLAKE" --no-root-passwd
#nixos-install --flake "$FLAKE_DIR#$DEFAULT_FLAKE" --no-root-passwd --root /mnt
#TMPDIR=/mnt/tmp nixos-install --flake /mnt/root/flake#$DEFAULT_FLAKE --no-root-passwd --root /mnt