#!/bin/bash

#build iso
nix build .#nixosConfigurations.proxmox-iso.config.system.build.isoImage && scp ./result/iso/nixos-minimal-25.11.20260306.71caefc-x86_64-linux.iso root@192.168.178.199:/var/lib/vz/template/iso/nixos-minimal-custom-installer-x86_64-linux.iso