{
  description = "My Homeserver Infrastructure with Nixos Configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      inputs,
      nixpkgs,
      sops-nix
    }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        # Main homeserver
        homeserver-alfa = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            sops-nix.nixosModules.sops
            ./hosts/homeserver-alfa/configuration.nix
            ./hosts/homeserver-alfa/hardware-configuration.nix
          ];
        };

        # Test server
        homeserver-alfa-test = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/homeserver-alfa-test/configuration.nix
            ./hosts/homeserver-alfa-test/hardware-configuration.nix
          ];
        };
      };
    };
}

#relay-server = nixpkgs.lib.nixosSystem {
#  inherit system;
#  modules = [
#    ./hosts/relay-server/configuration.nix
#    ./modules/nginx.nix
#    ./modules/tailscale.nix
#  ];
#};

#test-vm = nixpkgs.lib.nixosSystem {
#  inherit system;
#  modules = [
#    ./hosts/test-vm/configuration.nix
#  ];
#};
