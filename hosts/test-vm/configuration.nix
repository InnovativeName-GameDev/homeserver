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
  environment.systemPackages = with pkgs; [
    # --- Lightweight / safe ---
    btop # system monitor
    htop # process monitor
    vim # text editor
    nano # alternative lightweight editor
    wget # HTTP client
    curl # HTTP client
    git # version control
    unzip # zip extraction
    tmux # terminal multiplexer
    fd # fast file search
    ripgrep # CLI search tool, builds medium
    tree # directory listing
    lsof # open files monitor
    net-tools # basic networking tools
    iproute2 # ip commands

    # --- Medium RAM usage ---
    python3 # interpreter
    python3Packages.numpy # small C extensions
    python3Packages.scipy # memory-heavy extensions
    nodejs # JavaScript runtime
    go # Go compiler
    rustc # Rust compiler
    cmake # build system, medium RAM
    pkg-config # helper for C libraries
    gcc # C compiler
    clang # C/C++ compiler
    ripgrep # Rust CLI tool
    jq # JSON processor
    fd # fast file search
    openssh # SSH client/server

    # --- Heavy / RAM-intensive (stress test packages) ---
    ghc # Glasgow Haskell Compiler
    emacs # builds many files, medium to heavy
    llvm # very heavy
    python3Packages.pandas # builds C extensions
    python3Packages.matplotlib # builds heavy dependencies
    nodePackages.typescript # builds TypeScript compiler from source
  ];
  #environment.systemPackages = with pkgs; [
  #  btop
  #];
}
