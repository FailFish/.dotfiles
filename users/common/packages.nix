{ pkgs }:

with pkgs; [
  # docker
  # docker-compose
  bat
  broot
  coreutils
  curl
  fd
  fishPlugins.done
  # fishPlugins.fzf-fish
  fishPlugins.hydro
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
  tokei
  tree
  tmux
  unzip
  vim
  wget
  claude-code
  codex
  zip
  zk
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
