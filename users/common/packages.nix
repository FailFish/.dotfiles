{ pkgs }:

with pkgs; [
  # docker
  # docker-compose
  bat
  broot
  coreutils
  curl
  fd
  fzf
  gcc
  git
  glow
  htop
  jq
  lazygit
  libnotify # notify-send
  nix-template
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
++ lib.optionals (pkgs.stdenv.isLinux) [
  webcord-vencord
  zotero
  gnome-network-displays
  wpa_supplicant_gui
  mattermost-desktop
]
