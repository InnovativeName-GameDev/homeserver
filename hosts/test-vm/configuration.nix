{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ../../modules/pve-base.nix
  ];

  #configure autoUpgrade!
  system.autoUpgrade.flake = "github:InnovativeName-GameDev/homeserver#test-vm";

  #Network
  networking.hostName = "pve-test-vm";

  # compilcation test
  #environment.systemPackages = with pkgs; [
  #  # --- Lightweight / CLI essentials ---
  #  btop
  #  htop
  #  vim
  #  nano
  #  emacs
  #  neovim
  #  wget
  #  curl
  #  git
  #  unzip
  #  tar
  #  gzip
  #  bzip2
  #  xz
  #  tmux
  #  screen
  #  tree
  #  lsof
  #  net-tools
  #  iproute2
  #  jq
  #  fd
  #  fzf
  #  ripgrep
  #  bat
  #  ncdu
  #  socat
  #  openssh
  #  openssl
  #  rsync
  #  less
  #  man
  #  strace
  #  gdb
  #  bc
  #  coreutils
  #  findutils
  #  diffutils
  #  file
  #  shellcheck
  #  parallel
  #  ethtool
  #  iperf
  #  wget
  #  curl
  #  unzip
  #  zip
  #  p7zip
#
  #  # --- Medium / developer tools ---
  #  python3
  #  python3Packages.numpy
  #  python3Packages.scipy
  #  python3Packages.matplotlib
  #  python3Packages.pandas
  #  python3Packages.requests
  #  python3Packages.jinja2
  #  nodejs
  #  nodePackages.typescript
  #  go
  #  rustc
  #  cargo
  #  cmake
  #  pkg-config
  #  make
  #  gcc
  #  clang
  #  autoconf
  #  automake
  #  gnumake
  #  nasm
  #  perl
  #  ruby
  #  lua
  #  golang
  #  protobuf
  #  pkg-config
#
  #  # --- Medium-heavy / libraries and stress-test packages ---
  #  haskellPackages.lens
  #  haskellPackages.text
  #  haskellPackages.cabal-install
  #  ghc
  #  llvm
  #  emacsPackages.melpaPackages.org
  #  python3Packages.scikit-learn
  #  python3Packages.tensorflow
  #  python3Packages.opencv
  #  python3Packages.cython
  #  nodePackages.electron
  #  nodePackages.angular-cli
  #  rustPackages.ripgrep
  #  rustPackages.exa
  #  rustPackages.fzf
  #  goPackages.gitea
  #  goPackages.hugo
#
  #  # --- Very heavy / build stress-test (expect OOM without swap) ---
  #  ghc
  #  llvm
  #  haskellPackages.ghc
  #  haskellPackages.pandoc
  #  python3Packages.scipy
  #  python3Packages.tensorflow
  #  python3Packages.numpy
  #  nodePackages.electron
  #  rustPackages.ripgrep
  #  rustPackages.alacritty
  #];
  environment.systemPackages = with pkgs; [
    btop
  ];
}
