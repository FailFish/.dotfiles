{ inputs, ... }: {
  modifications = final: prev: {
    # Waybar with experimental features (needed for Hyprland workspace modules)
    # https://github.com/nixos/nixpkgs/issues/157101
    waybar = prev.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    });
  };

  # Neovim nightly — replaces pkgs.neovim with the latest nightly build.
  # programs.neovim in home.nix picks this up automatically.
  neovim-nightly = inputs.neovim-nightly-overlay.overlays.default;

  # Claude Code CLI — adds pkgs.claude-code
  claude-code = inputs.claude-code-nix.overlays.default;

  # Codex CLI — adds pkgs.codex-cli
  codex-cli = inputs.codex-cli-nix.overlays.default;
}
