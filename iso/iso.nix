{ pkgs, ... }:

{
  # Enable flakes and nix-command experimental features system-wide
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.grub.enable = false;
  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    gnupg
    git
  ];


  # Include encrypted SSH key in ISO
  environment.etc."secrets/nixos_deploy_key".source = ../secrets/nixos_deploy_key;
  environment.etc."secrets/nixos_deploy_key".mode = "0600";

  # Copy install script into the live user's home
  environment.etc."install.sh".source = ./install.sh;
  environment.etc."install.sh".mode = "0755";

  # Run install.sh for the live user
  users.users.liveuser = {
    isNormalUser = true;
    home = "/home/liveuser";
    shell = pkgs.bash;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keys = [];
    dotfiles = {
      ".bash_profile".text = ''
        echo "Welcome to the installer!"
        read -p "Press ENTER to start installation..."
        sudo /etc/install.sh
      '';
    };
  };


  #system.activationScripts
  # Optional: run some setup script on ISO boot
  system.activationScripts.iso-bootstrap.text = ''
    echo "Booted live ISO";
  '';
  
}