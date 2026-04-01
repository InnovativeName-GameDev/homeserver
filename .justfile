default:
    just --list

check:
    nix flake check

sops-edit:
    sops secrets/secrets.yaml