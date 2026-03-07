{
  description = "My Homeserver Infrastructure with Nixos Configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

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
        proxmox-iso = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            (nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
            (nixpkgs + "/nixos/modules/installer/cd-dvd/channel.nix")
            ./iso/iso.nix
          ];
        };

        test-vm = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            disko.nixosModules.disko
            ./hosts/test-vm/configuration.nix
          ];

        };

        nginx-homeserver = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            disko.nixosModules.disko
            (nixpkgs + "/nixos/modules/virtualisation/qemu-vm.nix")
            ./hosts/nginx-homeserver/configuration.nix
            ./modules/vm-disko-config.nix
            #./modules/nginx.nix
            #./modules/tailscale.nix
          ];
        };

        nginx-relay-server = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            (nixpkgs + "/nixos/modules/virtualisation/qemu-vm.nix")
            ./hosts/nginx-relay-server/configuration.nix
            ./modules/nginx.nix
            ./modules/tailscale.nix
          ];
        };

      };
    };
}
