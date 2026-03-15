{
  description = "My Homeserver Infrastructure with Nixos Configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    #sops-nix = {
    #  url = "github:Mic92/sops-nix";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
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
        #proxmox-iso = nixpkgs.lib.nixosSystem {
        #  inherit system;
        #  modules = [
        #    (nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
        #    (nixpkgs + "/nixos/modules/installer/cd-dvd/channel.nix")
        #    ./iso/iso.nix
        #  ];
        #};

        homeserver-alfa = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/homeserver-alfa/configuration.nix
            ./hosts/homeserver-alfa/hardware-configuration.nix
          ];
        };

        homeserver-alfa-test = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/homeserver-alfa-test/configuration.nix
            ./hosts/homeserver-alfa-test/hardware-configuration.nix
          ];
        };

        #pve-nginx = nixpkgs.lib.nixosSystem {
        #  inherit system;
        #  modules = [
        #    ./hosts/pve-nginx/configuration.nix
        #  ];
        #};

        #pve-nextcloud = nixpkgs.lib.nixosSystem {
        #  inherit system;
        #  modules = [
        #    ./hosts/pve-nextcloud/configuration.nix
        #  ];
        #};

        #pve-paperless-ngx = nixpkgs.lib.nixosSystem {
        #  inherit system;
        #  modules = [
        #    ./hosts/pve-paperless-ngx/configuration.nix
        #  ];
        #};

        #pve-plantuml = nixpkgs.lib.nixosSystem {
        #  inherit system;
        #  modules = [
        #    ./hosts/pve-plantuml/configuration.nix
        #  ];
        #};

        #pve-jenkins = nixpkgs.lib.nixosSystem {
        #  inherit system;
        #  modules = [
        #    ./hosts/pve-jenkins/configuration.nix
        #  ];
        #};

        #pve-jellyfin = nixpkgs.lib.nixosSystem {
        #  inherit system;
        #  modules = [
        #    ./hosts/pve-jellyfin/configuration.nix
        #  ];
        #};

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
      };
    };
}
