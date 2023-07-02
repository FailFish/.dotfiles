{ pkgs }:

with pkgs; [
  # docker
  # docker-compose
  bat
  broot
  coreutils
  curl
  exa
  fd
  fzf
  gcc
  git
  glow
  htop
  jq
  lazygit
  nix-template
  nnn
  openssh
  procs
  python3
  ripgrep
  sd
  texlive.combined.scheme-full
  tldr
  tokei
  tree
  unzip
  vim
  wget
  zip
  zk
  zoxide
]
# ++ lib.optionals (pkgs.stdenv.isDarwin) [
# ]
