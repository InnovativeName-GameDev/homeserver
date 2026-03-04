#!/usr/bin/env bash
set -euxo pipefail

FLAKE_REPO="https://github.com/InnovativeName-GameDev/homeserver.git"
FLAKE_DIR="/mnt/root/flake"
HOST="nginx-homeserver"

echo "Waiting for network..."
until ping -c1 github.com >/dev/null 2>&1; do sleep 1; done

git clone "$FLAKE_REPO" "$FLAKE_DIR"

echo "Running disko..."
disko \
  --mode destroy,format,mount \
  "$FLAKE_DIR/modules/vm-disko-config.nix"

echo "Installing NixOS..."
nixos-install \
  --flake "$FLAKE_DIR#$HOST" \
  --no-root-passwd

reboot