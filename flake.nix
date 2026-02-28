{
  description = "My Homeserver Infrastructure with Nixos Configs";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations = {
      iso = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ 
            ./iso/iso.nix
        ];
      };

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