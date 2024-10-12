# darwin specific system settings
{ inputs, outputs, lib, config, pkgs, ... }:
let
  user = "noah";
in
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

  system.stateVersion = 4;
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
  users.users.${user} = {
    home = "/Users/${user}";
    shell = pkgs.bashInteractive;
  };

  # I don't know what this is
  services.activate-system.enable = true;

  # Auto upgrade nix packages and the daemon services.
  services.nix-daemon.enable = true;
  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  # A list of permissible shells
  environment.shells = [ pkgs.bashInteractive ];

  # system-wide default programs
  # programs.info.enable = true;
  # programs.man.enable = true;
  programs.nix-index.enable = true;
  programs.vim.enable = true;
  # programs.vim.enableSensible = true;

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      # https://nixos.wiki/wiki/Fonts
      (nerdfonts.override { fonts = [ "RobotoMono" "JetBrainsMono" ]; })
    ];
  };

  services.tailscale.enable = true;

  /*
    # yabai / skhd settings
    services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    package = pkgs.yabai;
    # config = { };
    extraConfig = ''
      yabai -m config                             \
      mouse_follows_focus          off            \
      focus_follows_mouse          off            \
      window_origin_display        default        \
      window_placement             second_child   \
      window_topmost               off            \
      window_shadow                on             \
      window_animation_duration    0.0            \
      window_opacity_duration      0.0            \
      active_window_opacity        1.0            \
      normal_window_opacity        0.90           \
      window_opacity               off            \
      insert_feedback_color        0xffd75f5f     \
      active_window_border_color   0xff775759     \
      normal_window_border_color   0xff555555     \
      window_border_width          4              \
      window_border_radius         12             \
      window_border_blur           off            \
      window_border_hidpi          on             \
      window_border                off            \
      split_ratio                  0.50           \
      split_type                   auto           \
      auto_balance                 off            \
      top_padding                  10             \
      bottom_padding               10             \
      left_padding                 10             \
      right_padding                10             \
      window_gap                   10             \
      layout                       bsp            \
      mouse_modifier               fn             \
      mouse_action1                move           \
      mouse_action2                resize         \
      mouse_drop_action            swap

      yabai -m rule --add app="^System Preferences$" manage=off
      yabai -m rule --add app="^Archive Utility$" manage=off
      yabai -m rule --add app="^Spotify$" manage=off

      echo "yabai configuration loaded.."
    '';
    };

    services.skhd = {
    enable = true;
    package = pkgs.skhd;
    skhdConfig = let
      baseMod = "cmd";
      moveMod = "shift + ${baseMod}";
      sizeMod = "ctrl + ${baseMod}";
    in ''
      # Apps
      # alacritty-yabai issue: https://github.com/koekeishiya/yabai/issues/1250
      ${baseMod} - return : open -na ${pkgs.alacritty}/Applications/Alacritty.app
      ${baseMod} - b : open -n -a /Applications/Firefox.app

      # close the focused window
      ${baseMod} - x : yabai -m window --close

      # Windows
      # focus window
      ${baseMod} - h : yabai -m window --focus west
      ${baseMod} - j : yabai -m window --focus south
      ${baseMod} - k : yabai -m window --focus north
      ${baseMod} - l : yabai -m window --focus east

      # swap managed window
      ${moveMod} - h : yabai -m window --swap west
      ${moveMod} - l : yabai -m window --swap east
      ${moveMod} - j : yabai -m window --swap south
      ${moveMod} - k : yabai -m window --swap north

      # toggle window zoom
      ${baseMod} - m : yabai -m window --toggle zoom-fullscreen
      # rotate tree
      ${moveMod} - r : yabai -m space --rotate 90

      # float / unfloat window and center on screen
      ${baseMod} - t : yabai -m window --toggle float;\
                 yabai -m window --grid 4:4:1:1:2:2

      # balance the ratio
      # ${sizeMod} - b : yabai -m space --balance
      # resizing windows
      # ${sizeMod} - h : yabai -m window --resize left:-20:0
      # ${sizeMod} - l : yabai -m window --resize left:0:20
      # ${sizeMod} - j : yabai -m window --resize bottom:0:-20
      # ${sizeMod} - k : yabai -m window --resize top:0:-20

      # desktops(spaces)
      # focus desktops
      # ${baseMod} - 1 : yabai -m space --focus 1
      # ${baseMod} - 2 : yabai -m space --focus 2
      # ${baseMod} - 3 : yabai -m space --focus 3
      # ${baseMod} - 4 : yabai -m space --focus 4
      # ${baseMod} - 5 : yabai -m space --focus 5
      # ${baseMod} - 6 : yabai -m space --focus 6
      # ${baseMod} - 7 : yabai -m space --focus 7
      # ${baseMod} - 8 : yabai -m space --focus 8
      # ${baseMod} - 9 : yabai -m space --focus 9
      # send window to desktop
      ${moveMod} - 1 : yabai -m window --space 1
      ${moveMod} - 2 : yabai -m window --space 2
      ${moveMod} - 3 : yabai -m window --space 3
      ${moveMod} - 4 : yabai -m window --space 4
      ${moveMod} - 5 : yabai -m window --space 5
      ${moveMod} - 6 : yabai -m window --space 6
      ${moveMod} - 7 : yabai -m window --space 7
      ${moveMod} - 8 : yabai -m window --space 8
      ${moveMod} - 9 : yabai -m window --space 9

    '';
    };
  */
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
