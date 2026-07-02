# darwin specific system settings
{ inputs, outputs, lib, config, pkgs, ... }:
{
  imports = [
    ./homebrew.nix
    ../pkgs/aerospace/module.nix
  ];

  # https://github.com/nix-community/home-manager/issues/2942#issuecomment-1378627909
  nixpkgs = {
    # vscode requires unfree
    config.allowUnfree = true;
    # unsupported packages in aarch64 sometimes work well
    config.allowUnsupportedSystem = true;
  };

  # > The user used for options that previously applied to the user running darwin-rebuild.
  # > This is a transition mechanism as nix-darwin reorganizes its options and will eventually be unnecessary and removed.
  system.primaryUser = "taehyun";
  system.stateVersion = 6;
  system.defaults = {
    dock = {
      autohide = true;
      orientation = "left";
      launchanim = false;
      mineffect = "scale";
      showhidden = true;
      tilesize = 48;
      # static-only = true; # show running apps only
    };
    finder = {
      AppleShowAllExtensions = true;
    };
    NSGlobalDomain = {
      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 15;
      KeyRepeat = 1;
      "com.apple.swipescrolldirection" = false;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
    };
  };
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
    swapLeftCommandAndLeftAlt = true;
    userKeyMapping =
      let
        rcmd_keycode = 30064771303;
        f18_keycode = 30064771181;
      in
      [
        {
          # f18: manually set as input source switcher via macOS
          # remap right command to f18
          HIDKeyboardModifierMappingSrc = rcmd_keycode;
          HIDKeyboardModifierMappingDst = f18_keycode;
        }
      ];
  };

  # user-specific setting (for home-manager)
  programs.fish.enable = true;
  users.users.${config.system.primaryUser} = {
    home = "/Users/${config.system.primaryUser}";
    uid = 501;
    shell = pkgs.fish;
  };
  users.knownUsers = [ config.system.primaryUser ];

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  # system-wide default programs
  # programs.info.enable = true;
  # programs.man.enable = true;
  programs.nix-index.enable = true;

  fonts = {
    packages = with pkgs; [
      # https://nixos.wiki/wiki/Fonts
      nerd-fonts.roboto-mono
      nerd-fonts.jetbrains-mono
    ];
  };

  services.tailscale.enable = true;

  programs.aerospace = {
    enable = true;
    enableJankyBorders = true;
    settings = {
      after-startup-command = [
        "exec-and-forget ${pkgs.jankyborders}/bin/borders style=round width=10 active_color=0xffeba0ac"
      ];

      # Normalizations. See: https://nikitabobko.github.io/AeroSpace/guide#normalization
      enable-normalization-flatten-containers = false;
      enable-normalization-opposite-orientation-for-nested-containers = false;

      accordion-padding = 30;

      # Possible values: tiles|accordion
      default-root-container-layout = "tiles";

      # mouse cursor follows the focus
      on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];

      gaps = {
        inner = {
          horizontal = 10;
          vertical = 10;
        };
        outer = {
          left = 10;
          bottom = 10;
          top = 10;
          right = 10;
        };
      };

      workspace-to-monitor-force-assignment = {
        "1" = [ "main" ];
        "2" = [ "main" ];
        "3" = [ "main" ];
        "4" = [ "main" ];
        "5" = [ "main" ];
        "6" = [ "secondary" ];
        "7" = [ "secondary" ];
        "8" = [ "secondary" ];
        "9" = [ "secondary" ];
        "10" = [ "secondary" ];
      };

      # All possible keys:
      # - Letters.        a, b, c, ..., z
      # - Numbers.        0, 1, 2, ..., 9
      # - Keypad numbers. keypad0, keypad1, keypad2, ..., keypad9
      # - F-keys.         f1, f2, ..., f20
      # - Special keys.   minus, equal, period, comma, slash, backslash, quote, semicolon, backtick,
      #                   leftSquareBracket, rightSquareBracket, space, enter, esc, backspace, tab
      # - Keypad special. keypadClear, keypadDecimalMark, keypadDivide, keypadEnter, keypadEqual,
      #                   keypadMinus, keypadMultiply, keypadPlus
      # - Arrows.         left, down, up, right
      mode = {
        main.binding =
          let
            baseMod = "alt";
            moveMod = "shift-${baseMod}";
            sizeMod = "ctrl-${baseMod}";
          in
          {
            # Apps
            "${baseMod}-enter" = "exec-and-forget open -na ${pkgs.alacritty}/Applications/Alacritty.app";
            "${baseMod}-b" = "exec-and-forget open -n -a /Applications/Firefox.app";

            "${moveMod}-c" = "reload-config";

            # Windows
            # close focused window
            "${baseMod}-x" = "close";

            # Focus active window in direction
            "${baseMod}-h" =
              "focus left --boundaries all-monitors-outer-frame --boundaries-action wrap-around-all-monitors";
            "${baseMod}-j" = "focus down --boundaries-action wrap-around-the-workspace";
            "${baseMod}-k" = "focus up --boundaries-action wrap-around-the-workspace";
            "${baseMod}-l" =
              "focus right --boundaries all-monitors-outer-frame --boundaries-action wrap-around-all-monitors";

            # move a window in direction
            "${moveMod}-h" = "move left";
            "${moveMod}-j" = "move down";
            "${moveMod}-k" = "move up";
            "${moveMod}-l" = "move right";

            "${baseMod}-t" = "layout floating tiling"; # floating toggle
            "${moveMod}-r" = "flatten-workspace-tree"; # reset layout

            "${baseMod}-m" = "fullscreen"; # toggle zoom
            "${baseMod}-s" = "layout tiles horizontal vertical"; # rotate

            # workspaces
            "${baseMod}-1" = "workspace 1";
            "${baseMod}-2" = "workspace 2";
            "${baseMod}-3" = "workspace 3";
            "${baseMod}-4" = "workspace 4";
            "${baseMod}-5" = "workspace 5";
            "${baseMod}-6" = "workspace 6";
            "${baseMod}-7" = "workspace 7";
            "${baseMod}-8" = "workspace 8";
            "${baseMod}-9" = "workspace 9";
            "${baseMod}-0" = "workspace 10";

            "${moveMod}-1" = "move-node-to-workspace 1";
            "${moveMod}-2" = "move-node-to-workspace 2";
            "${moveMod}-3" = "move-node-to-workspace 3";
            "${moveMod}-4" = "move-node-to-workspace 4";
            "${moveMod}-5" = "move-node-to-workspace 5";
            "${moveMod}-6" = "move-node-to-workspace 6";
            "${moveMod}-7" = "move-node-to-workspace 7";
            "${moveMod}-8" = "move-node-to-workspace 8";
            "${moveMod}-9" = "move-node-to-workspace 9";
            "${moveMod}-0" = "move-node-to-workspace 10";

            "${baseMod}-r" = "mode resize";
          };

        resize.binding = {
          "h" = "resize width -20";
          "j" = "resize height -20";
          "k" = "resize height +20";
          "l" = "resize width +20";
          "enter" = "mode main";
          "esc" = "mode main";
        };
      };
    };
  };
}
