{ ... }:
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

  # Define your hostname.
  networking.hostName = "pve-nixos-installer";

  # Configure console keymap
  console.keyMap = "de";

  # Nix build configuration for low-RAM VM
  nix.settings.max-jobs = 1; # build one derivation at a time
  nix.settings.cores = 1; # build one core at a time

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
