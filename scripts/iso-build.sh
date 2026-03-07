#!/bin/bash

nix build .#nixosConfigurations.proxmox-iso.config.system.build.isoImage
