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
      nixpkgs,
      sops-nix,
      ...
    } @ inputs: let
      inherit (self) outputs;
      vars = import ./vars.nix;

      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        # Main homeserver
        homeserver-alfa = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/homeserver-alfa/configuration.nix
            sops-nix.nixosModules.sops
          ];
          specialArgs = {inherit inputs outputs vars;};
        };

        # Test server
        homeserver-alfa-test = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/homeserver-alfa-test/configuration.nix
            ./hosts/homeserver-alfa-test/hardware-configuration.nix
          ];
          specialArgs = {inherit inputs outputs vars;};
        };

        #iso-installer = nixpkgs.lib.nixosSystem {
        #  modules = [
        #    ./hosts/iso-installer/configuration.nix
        #  ];
        #}
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
