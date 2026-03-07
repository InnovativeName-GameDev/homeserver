{
  description = "My Homeserver Infrastructure with Nixos Configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs =
    {
      self,
      nixpkgs,
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
            ./hosts/test-vm/configuration.nix
          ];
        };

        pve-reverse-proxy = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/pve-reverse-proxy/configuration.nix
          ];
        };

        relay-server = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/relay-server/configuration.nix
            ./modules/nginx.nix
            ./modules/tailscale.nix
          ];
        };

      };
    };
}
