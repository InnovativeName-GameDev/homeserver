{
  description = "Two NGINX systems with Nix flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations = {

      nginx-homeservere = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/nginx-homeserver/configuration.nix
          ./modules/nginx-common.nix
        ];
      };

      nginx-relay-server = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/nginx-relay-server/configuration.nix
          ./modules/nginx-common.nix
        ];
      };

    };
  };
}