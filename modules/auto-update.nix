{
  # inspo: https://github.com/eh8/chenglab/blob/main/modules/nixos/auto-update.nix
  system.autoUpgrade = {
    enable = true;
    dates = "02:00";
    randomizedDelaySec = "1h";
    flake = "github:InnovativeName-GameDev/homeserver";
  };
}