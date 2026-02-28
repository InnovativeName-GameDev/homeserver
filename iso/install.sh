#!/usr/bin/env bash
set -e

# Paths
DEPLOY_KEY=/root/.ssh/id_ed25519
FLAKE_DIR=/root/flake

mkdir -p /root/.ssh

# Copy the key if not present (for now plain text)
if [ ! -f "$DEPLOY_KEY" ]; then
  cp /etc/ssh/id_ed25519 "$DEPLOY_KEY"
  chmod 600 "$DEPLOY_KEY"
fi

# Clone flake if not already present
if [ ! -d "$FLAKE_DIR" ]; then
  echo "Cloning flake..."
  git clone git@github.com:InnovativeName-GameDev/homeserver.git "$FLAKE_DIR"
fi

# Flake selection (choose default or first one)
DEFAULT_FLAKE="hostname"
echo "Building default flake: $DEFAULT_FLAKE"

# Rebuild system using flake
nixos-install --flake "$FLAKE_DIR#$DEFAULT_FLAKE"