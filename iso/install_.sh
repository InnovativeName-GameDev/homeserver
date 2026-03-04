#!/usr/bin/env bash
set -euxo pipefail

DISK="${1:-/dev/sda}"
FLAKE_DIR="/mnt/root/flake"
DEFAULT_FLAKE="nginx-homeserver"

echo "Installing to $DISK"
read -p "WARNING: This will erase $DISK. Continue? (yes/no) " CONFIRM
[ "$CONFIRM" = "yes" ] || exit 1

echo "Waiting for network..."
until ping -c1 github.com >/dev/null 2>&1; do sleep 1; done

# Partition (GPT for BIOS + UEFI compatibility)
parted "$DISK" -- mklabel gpt

# EFI partition
parted "$DISK" -- mkpart ESP fat32 1MiB 512MiB
parted "$DISK" -- set 1 esp on

# Root partition
parted "$DISK" -- mkpart primary ext4 512MiB 100%

mkfs.vfat -F32 -n EFI "${DISK}1"
mkfs.ext4 -L nix "${DISK}2"

# Mount root as tmpfs
mount -t tmpfs none /mnt

mkdir -p /mnt/{boot/efi,nix,etc/{nixos,ssh},var/{lib,log},srv}
mount "${DISK}1" /mnt/boot/efi
mount "${DISK}2" /mnt/nix

mkdir -p /mnt/nix/persist/{etc/{nixos,ssh},var/{lib,log},srv}

mount -o bind /mnt/nix/persist/etc/nixos /mnt/etc/nixos
mount -o bind /mnt/nix/persist/var/log /mnt/var/log

mkdir -p /mnt/nix/var/nix
chown -R root:root /mnt
chmod -R 755 /mnt

if [ ! -d "$FLAKE_DIR" ]; then
  echo "Cloning flake..."
  git clone git@github.com:InnovativeName-GameDev/homeserver.git "$FLAKE_DIR"
fi

echo "Installing flake: $DEFAULT_FLAKE"
nixos-install \
  --flake "$FLAKE_DIR#$DEFAULT_FLAKE" \
  --no-root-passwd \
  --root /mnt

echo "Installation complete. Rebooting..."
reboot