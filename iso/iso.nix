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

  # Enable networking
  networking.wireless.enable = false;
  networking.networkmanager.enable = true;
  networking.networkmanager.dhcp = true;
  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
    "8.8.8.8"
    "8.8.4.4"
  ];

  # Define your hostname.
  networking.hostName = "pve-nixos-installer";

  # Configure console keymap
  console.keyMap = "de";

  # Installed Software
  #environment.systemPackages = with pkgs; [];

  # Copy install.sh into home directory
  environment.etc."install.sh".source = ./install.sh;
  # Optional: Make it executable
  environment.etc."install.sh".mode = "0755";

  # Add hint for the user about what todo
  environment.etc."profile.local".text = ''
    echo "please run \"sudo /etc/install.sh\" for installation."
  '';
  environment.etc."profile.local".mode = "0755";
}
