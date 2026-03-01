#!/bin/bash
nix build .#nixosConfigurations.iso.config.system.build.isoImage
#nix build .#nixosConfigurations.nginx-homeserver.config.system.build.isoImage