#!/usr/bin/env bash
set -e

# Paths
ENCRYPTED_KEY=/etc/ssh/id_ed25519.gpg
DECRYPTED_KEY=/root/.ssh/id_ed25519
FLAKE_DIR=/root/flake

mkdir -p /root/.ssh

# Prompt for passphrase
if [ ! -f "$DECRYPTED_KEY" ]; then
  echo "Enter passphrase to decrypt deploy key:"
  gpg --quiet --batch --decrypt --output "$DECRYPTED_KEY" "$ENCRYPTED_KEY"
  chmod 600 "$DECRYPTED_KEY"
fi

# Clone flake if not already present
if [ ! -d "$FLAKE_DIR" ]; then
  echo "Cloning flake..."
  git clone git@github.com:InnovativeName-GameDev/homeserver.git "$FLAKE_DIR"
fi

# Flake selection (choose default or first one)
DEFAULT_FLAKE="hostname"
echo "Building default flake: $DEFAULT_FLAKE"
sudo nixos-rebuild switch --flake "$FLAKE_DIR#$DEFAULT_FLAKE"