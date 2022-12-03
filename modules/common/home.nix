{ pkgs, lib, ... }:
let
  rootdir = ./../..;
  cfgdir = rootdir + "/.config";
in
{
  home = {
    stateVersion = "22.05";
    packages = pkgs.callPackage ./packages.nix {};
  };

  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
    enableCompletion = true;
    initExtra = builtins.readFile (rootdir + "/.bashrc") + ''
      if command -v fzf-share >/dev/null; then
        source "$(fzf-share)/key-bindings.bash"
        source "$(fzf-share)/completion.bash"
      fi

      # :help vimtex-faq-zathura-macos
      export DBUS_SESSION_BUS_ADDRESS="unix:path=$DBUS_LAUNCHD_SESSION_BUS_SOCKET"
    '';
  };
  # home.file.".bashrc".source = rootdir + "/.bashrc";

  programs.tmux = {
    enable = true;
    /*
    plugins = with pkgs; [
      tmuxPlugins.cpu
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '60' # minutes
        '';
      }
    ];
    */
  };
  xdg.configFile."tmux".source = cfgdir + "/tmux";

  programs.alacritty.enable = true;
  xdg.configFile."alacritty".source = cfgdir + "/alacritty";

  programs.neovim = {
    enable = true;
    # package = 
    viAlias = false;
    vimAlias = false;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

    # extraConfig = '' '';

    extraPackages = with pkgs; [

      # lua
      sumneko-lua-language-server
      stylua

      # C/C++
      clang-tools
      # cmake-language-server

      # Rust
      rust-analyzer
      rustfmt
      clippy

      # bash
      nodePackages.bash-language-server
      shfmt
      shellcheck

      # python3
      nodePackages.pyright
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
      nil
      statix

      # general writting
      nodePackages.write-good

      # etc
      nodePackages.vim-language-server
      nodePackages.prettier

    ] ++ lib.optionals pkgs.stdenv.isLinux [
      # packages only available in Linux
      ltex-ls
    ];


    plugins = with pkgs.vimPlugins; [
      # dev
      plenary-nvim
      popup-nvim
      impatient-nvim

      # navigation
      vim-matchup
      # leap-nvim

      # editing
      comment-nvim
      splitjoin-vim
      vim-abolish
      vim-surround

      # lsp
      nvim-lspconfig
      lsp-status-nvim
      symbols-outline-nvim
      null-ls-nvim
      lsp_signature-nvim
      nvim-code-action-menu
      clangd_extensions-nvim
      rust-tools-nvim

      # debug
      # nvim-gdb
      nvim-dap
      nvim-dap-ui
      nvim-dap-virtual-text
      telescope-dap-nvim
      nvim-dap-python
      # one-small-step-for-vimkind # not supported

      # completion-related
      nvim-cmp
      cmp-buffer
      cmp-path
      cmp-nvim-lua
      cmp-nvim-lsp
      cmp-nvim-lsp-document-symbol
      cmp-cmdline
      lspkind-nvim

      # Snippets
      luasnip
      friendly-snippets
      cmp_luasnip

      # telescope
      telescope-nvim
      telescope-file-browser-nvim
      telescope-fzf-native-nvim

      # treesitter
      nvim-treesitter

      # git-related
      neogit
      diffview-nvim
      gitsigns-nvim
      git-messenger-vim
      committia-vim
      gitlinker-nvim
      # lazygit-nvim

      # appearance
      gruvbox-material
      nvim-web-devicons
      feline-nvim
      toggleterm-nvim
      trouble-nvim
      alpha-nvim
      # nnn-nvim
      project-nvim

      # etc
      neorg
      vimtex
      vim-nix
    ];
  };

  # excluding nvim/plugin
  xdg.configFile."nvim/init.lua".source = cfgdir + "/nvim/init.lua";
  xdg.configFile."nvim/lua" = {
    recursive = true;
    source = cfgdir + "/nvim/lua";
  };

  programs.zathura.enable = true;
  xdg.configFile."zathura".source = cfgdir + "/zathura";

  programs.git = {
    enable = true;
    delta.enable = true;
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

  # Issues: not supported in aarch64-darwin
  # programs.firefox = {
  #   enable = true;
  #   extensions = with pkgs.nur.repos.rycee.firefox-addons; [
  #     https-everywhere
  #     privacy-badger
  #   ];
  # };

}
