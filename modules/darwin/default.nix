# darwin specific system settings
{ config, pkgs, ... }:
let
  user = "noah";
in {
  imports = [
    ./homebrew.nix
  ];

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

  # user-specific setting (for home-manager)
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    shell = pkgs.bashInteractive;
  };

  # I don't know what this is
  services.activate-system.enable = true;

  # Auto upgrade nix packages and the daemon services.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

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
      baseMod = "alt";
      moveMod = "shift + ${baseMod}";
      sizeMod = "ctrl + ${baseMod}";
    in ''
      # Apps
      # alacritty-yabai issue: https://github.com/koekeishiya/yabai/issues/1250
      ${baseMod} - return : open -na ${pkgs.alacritty}/Applications/Alacritty.app
      ${baseMod} - b : open -n -a /Applications/Safari.app

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
}
