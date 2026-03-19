{
  description = "My Homeserver Infrastructure with Nixos Configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    sops-nix = {
      url = "github:Mic92/sops-nix";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      sops-nix,
    }:
    let
      system = "x86_64-linux";

      # Import sops-nix
      sopsLib = import sops-nix;
    in
    {
      nixosConfigurations = {
        # Main homeserver
        homeserver-alfa = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/homeserver-alfa/configuration.nix
            ./hosts/homeserver-alfa/hardware-configuration.nix
            sopsLib.nixosModule # Enables SOPS integration
          ];
          specialArgs = { inherit sopsLib; };
        };

        # Test server
        homeserver-alfa-test = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/homeserver-alfa-test/configuration.nix
            ./hosts/homeserver-alfa-test/hardware-configuration.nix
            sopsLib.nixosModule
          ];
          specialArgs = { inherit sopsLib; };
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
