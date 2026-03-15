{
  nixpkgs,
  inputs,
  config,
  pkgs,
  vars,
  ...
}:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  nixpkgs.config.allowUnfree = true;
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  # Enable password feedback for sudo
  security.sudo.extraConfig = "Defaults pwfeedback";

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Configure console keymap and Locate
  console.keyMap = "de";

  #sops = {
  #  defaultSopsFile = ./../../secrets/secrets.yaml;
  #  age.sshKeyPaths = [ "/nix/secret/initrd/ssh_host_ed25519_key" ];
  #  secrets."user-password".neededForUsers = true;
  #  secrets."user-password" = { };
  #  # inspo: https://github.com/Mic92/sops-nix/issues/427
  #  gnupg.sshKeyPaths = [ ];
  #};

  #enable tailscale
  services.tailscale.enable = true;

  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
      openFirewall = true;
    };
  };

  networking = {
    firewall.enable = true;
    networkmanager.enable = true;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
