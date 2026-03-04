{
  description = "My Homeserver Infrastructure with Nixos Configs";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      disko,
    }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        iso = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
              <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
              <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
              ./iso/iso.nix
          ];
        };

        nginx-homeserver = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            disko.nixosModules.disko
            ./hosts/nginx-homeserver/configuration.nix
            ./modules/vm-disko-config.nix
            #./modules/nginx.nix
            #./modules/tailscale.nix
          ];
        };

        nginx-relay-server = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/nginx-relay-server/configuration.nix
            ./modules/nginx.nix
            ./modules/tailscale.nix
          ];
        };

      };
    };
}
