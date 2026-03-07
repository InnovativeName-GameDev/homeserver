#!/usr/bin/env bash
set -euxo pipefail

HOST="test-vm"

echo "Waiting for network..."
until ping -c1 github.com >/dev/null 2>&1; do sleep 1; done

nix run github:nix-community/disko -- --mode destroy,format,mount github:InnovativeName-GameDev/homeserver#test-vm

echo "Installing NixOS..."
nixos-install --flake github:InnovativeName-GameDev/homeserver#$HOST --no-root-passwd

reboot