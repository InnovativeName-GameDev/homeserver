{
  inputs,
  nixpkgs,
  pkgs,
  ...
}:

{
  imports = [ ];

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
  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
    "8.8.8.8"
    "8.8.4.4"
  ];

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

  # Copy install.sh into home directory
  environment.etc."install.sh".source = ./install.sh;
  # Optional: Make it executable
  environment.etc."install.sh".mode = "0755";

  #Just 
  environment.etc."profile.local".text = ''
  echo "please run \"sudo /etc/install.sh\" for installation."
  '';
  environment.etc."profile.local".mode = "0755";
}
