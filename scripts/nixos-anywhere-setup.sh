#!/bin/bash

#https://github.com/nix-community/nixos-anywhere/blob/main/docs/howtos/no-os.md

# 1. boot into live iso on new host
# 2. set a password with "passwd"
# 3. look for ip address with "ip addr"
# 4. test connection with: 
#ssh -v nixos@192.168.178.62
nix run github:nix-community/nixos-anywhere -- --flake .#nginx-homeserver --target-host nixos@192.168.178.62 --generate-hardware-config nixos-generate-config ./hosts/nginx-homeserver/hardware-configuration.nix
#nix run github:nix-community/nixos-anywhere -- --flake .#nixosConfigurations.nginx-homeserver --vm-test