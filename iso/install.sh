#!/usr/bin/env bash
set -e

DEPLOY_KEY=/root/.ssh/id_ed25519
FLAKE_DIR=/mnt/root/flake
DEFAULT_FLAKE="nginx-homeserver"

mkdir -p /mnt/root/.ssh

if [ ! -f "$DEPLOY_KEY" ]; then
  cp /etc/secrets/nixos_deploy_key "$DEPLOY_KEY"
  chmod 600 "$DEPLOY_KEY"
fi

if [ ! -d "$FLAKE_DIR" ]; then
  echo "Cloning flake..."
  git clone git@github.com:InnovativeName-GameDev/homeserver.git "$FLAKE_DIR"
fi

# Make sure nix store writes to disk
mkdir -p /mnt/nix
mount --bind /mnt/nix /nix

nixos-install --flake "$FLAKE_DIR#$DEFAULT_FLAKE"