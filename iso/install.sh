#!/usr/bin/env bash
set -euxo pipefail

FLAKE_REPO="https://github.com/InnovativeName-GameDev/homeserver.git"
FLAKE_DIR="/mnt/flake"
HOST="test-vm"

echo "Waiting for network..."
until ping -c1 github.com >/dev/null 2>&1; do sleep 1; done

# At this point, root is mounted at /mnt
# Make a directory for the flake inside the new root
mkdir -p "$FLAKE_DIR"

# Clone the flake now that /mnt exists
git clone "$FLAKE_REPO" "$FLAKE_DIR"

echo "Running disko..."
# This will format and mount partitions
disko --mode destroy,format,mount "$FLAKE_DIR/modules/vm-disko-config.nix"

# Ensure EFI partition is mounted correctly
mkdir -p /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi

echo "Installing NixOS..."
nixos-install --flake "$FLAKE_DIR#$HOST" --no-root-passwd

reboot