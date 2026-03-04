{ inputs, nixpkgs, pkgs, ... }:

{
  imports = [];


  # Enable flakes and nix-command experimental features system-wide
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot.loader.grub.enable = false;
  services.openssh.enable = true;

  # Enable networking
  networking.wireless.enable = false;
  networking.networkmanager.enable = true;
  networking.nameservers = ["1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4"];

  networking = {
    interfaces.ens18 = {
      ipv4.addresses = [
        {
          address = "192.168.178.250";
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = {
      address = "192.168.178.1";
      interface = "ens18";
    };
  };

  environment.systemPackages = with pkgs; [
    git
    disko
  ];

  systemd.services.autoInstall = {
    description = "Auto-install NixOS flake";
    wantedBy = [ "multi-user.target" ]; # ensures service runs at boot
    serviceConfig = {
      Type = "simple";
      StandardOutput = "journal+console";  # show logs in console
      StandardError = "journal+console";
    };
    script = ''
      set -euxo pipefail
      echo "Running auto-install..."
      git clone git@github.com:InnovativeName-GameDev/homeserver.git /root/flake
      disko --mode destroy,format,mount /root/flake/modules/vm-disko-config.nix
      nixos-install --flake /root/flake#nginx-homeserver --no-root-passwd
      echo "Installation complete. Rebooting..."
      reboot
    '';
  };
}
