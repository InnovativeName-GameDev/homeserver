#!/usr/bin/env bash
set -eux

HOST="test-vm"
REPO="github:InnovativeName-GameDev/homeserver"

until ping -c1 github.com >/dev/null 2>&1; do sleep 1; done

disko -- --mode destroy,format,mount "$REPO#$HOST"

nixos-install --flake "$REPO#$HOST" --no-root-passwd

reboot