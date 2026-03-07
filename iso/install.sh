#!/usr/bin/env bash
set -euo pipefail

DISK="/dev/sda"
HOSTNAME="test-vm"

# Flake repo
FLAKE="github:InnovativeName-GameDev/homeserver"

echo "Installing NixOS for $HOSTNAME using flake $FLAKE"

read -p "This will wipe $DISK. Continue? (y/N): " confirm
[[ "$confirm" == "y" ]] || exit 1

echo "Partitioning disk..."

parted -s "$DISK" -- \
 mklabel gpt \
 mkpart ESP fat32 1MiB 512MiB \
 name 1 ESP \
 set 1 esp on \
 mkpart primary ext4 512MiB 100%

echo "Formatting..."

mkfs.fat -F32 -n boot ${DISK}1
mkfs.ext4 -L nixos ${DISK}2

echo "Mounting..."

mount ${DISK}2 /mnt
mkdir -p /mnt/boot
mount ${DISK}1 /mnt/boot

echo "Installing NixOS..."

nixos-install \
 --flake "$FLAKE#$HOSTNAME" \
 --no-root-passwd

echo "Done. Reboot when ready."