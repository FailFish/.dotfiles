{ pkgs, lib, ... }:
let
  rootdir = ./../..;
  cfgdir = rootdir + "/.config";
in
{
  home = {
    stateVersion = "23.05";
    packages = pkgs.callPackage ./packages.nix {};
  };

  programs.home-manager.enable = true;
  programs.nix-index.enable = true;

  programs.bash = {
    enable = true;
    enableCompletion = true;
    initExtra = builtins.readFile (rootdir + "/.bashrc") + ''
      if command -v fzf-share >/dev/null; then
        source "$(fzf-share)/key-bindings.bash"
        source "$(fzf-share)/completion.bash"
      fi

      # hello for testing
      # :help vimtex-faq-zathura-macos
      export DBUS_SESSION_BUS_ADDRESS="unix:path=$DBUS_LAUNCHD_SESSION_BUS_SOCKET"

    '' + lib.optionalString pkgs.stdenv.isDarwin ''
      # Issue: https://discourse.nixos.org/t/brew-not-on-path-on-m1-mac/26770/4
      # make sure brew is on the path for M1
      if [[ $(uname -m) == 'arm64' ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      fi
    '';
    sessionVariables = {
      MANPAGER="nvim +Man!";
    };
  };
  # home.file.".bashrc".source = rootdir + "/.bashrc";
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.tmux = {
    enable = true;
    # BUG: https://github.com/nix-community/home-manager/issues/3555
    # TODO: https://github.com/nix-community/home-manager/pull/3801
    # extraConfig = builtins.readFile (cfgdir + "/tmux/tmux.conf");
    # plugins = with pkgs.tmuxPlugins; [
    #   cpu
    #   prefix-highlight
    #   tmux-fzf
    #   yank
    #   tmux-thumbs
    #   resurrect
    #   continuum
    # ];
  };
  xdg.configFile."tmux".source = cfgdir + "/tmux";

  programs.alacritty.enable = true;
  xdg.configFile."alacritty".source = cfgdir + "/alacritty";

  programs.neovim = {
    enable = true;
    package = pkgs.neovim; # nightly via neovim-nightly overlay
    viAlias = false;
    vimAlias = false;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;
    defaultEditor = true;

    # extraConfig = '' '';

    extraPackages = with pkgs; [
      gnumake

      # lua
      lua-language-server
      stylua

      # C/C++
      clang-tools
      cmake-language-server

      # Rust
      rust-analyzer
      rustfmt
      clippy

      # bash
      nodePackages.bash-language-server
      shfmt
      shellcheck

      # python3
      pyright
      black
      isort
      python3Packages.flake8

      # latex
      texlab
      proselint
      # texlive do not provide full dependencies so nix follows.
      # https://github.com/NixOS/nixpkgs/issues/56840
      python3Packages.pygments # texlive - minted

      # nix
      nixd
      statix
      nixpkgs-fmt

      # general writting
      nodePackages.write-good

      # etc
      zls
      gopls
      vscode-langservers-extracted
      vim-language-server
      nodePackages.prettier

    ] ++ lib.optionals pkgs.stdenv.isLinux [
      # packages only available in Linux
      ltex-ls
    ];


    # use its own plugin manager
    plugins = with pkgs.vimPlugins; [ ];
  };

  # excluding nvim/plugin
  xdg.configFile."nvim" = {
    recursive = true;
    source = cfgdir + "/nvim_lazy";
  };

  programs.zathura.enable = true;
  xdg.configFile."zathura".source = cfgdir + "/zathura";

  programs.sioyek.enable = true;

  programs.git = {
    enable = true;
    delta.enable = true;
    aliases = {
      graph = "log --decorate --oneline --graph";
    };
    userName = "Taehyun Noh";
    extraConfig = {
      init.defaultBranch = "main";
      merge.conflictStyle = "zdiff3";
      commit.verbose = true;
      diff.algorithm = "histogram";
      log.date = "iso";
      column.ui = "auto";
      branch.sort = "committerdate";
      # Automatically track remote branch
      # push.autoSetupRemote = true;
      rerere.enabled = true;
      transfer.fsckobjects = true;
      fetch.fsckobjects = true;
      receive.fsckObjects = true;
      merge.tool = "nvimdiff";
    };
  };
  xdg.configFile."git".source = cfgdir + "/git";

  programs.gh = {
    enable = true;
    extensions = with pkgs; [
      gh-dash
      gh-eco
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    extraOptions = [ "--group-directories-first" "--header" ];
    git = true;
    icons = "auto";
  };

  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.tealdeer.enable = true;

  programs.zellij = {
    enable = true;
  };

  # Issues: not supported in aarch64-darwin
  # programs.firefox = {
  #   enable = true;
  #   extensions = with pkgs.nur.repos.rycee.firefox-addons; [
  #     https-everywhere
  #     privacy-badger
  #   ];
  # };

}
