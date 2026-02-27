{ inputs, pkgs, config, ... }:
{
  imports = [
    ./common/home.nix
  ];

  home.username = "noah";
  home.homeDirectory = "/home/noah";

  # NixOS-only
  xdg.configFile."hypr".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/.config/hypr";
  xdg.configFile."waybar".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/.config/waybar";

  i18n = {
    inputMethod.type = {
      enabled = "kime";
      kime.extraConfig = "
        daemon:
          modules: [Wayland, Indicator]
        indicator:
          icon_color: White
        engine:
          hangul:
            layout: dubeolsik
      ";
    };
  };

  services.kanshi = {
    enable = true;
    systemdTarget = "graphical-session.target";
    settings = [
      { profile.name = "default";
        profile.outputs = [
          {
            # check man 5 kanshi
            criteria = "eDP-1";
            status = "enable";
          }
        ];
      }

      # WARN: Syntax might be wrong
      # { profile.name = "external-dp";
      #   profile.outputs = [
      #     {
      #       criteria = "DP-1";
      #       status = "enable";
      #       scale = 1.5;
      #     }
      #     {
      #       criteria = "eDP-1";
      #       status = "disable";
      #     }
      #   ];
      #   exec = "${pkgs.libnotify}/bin/notify-send --expire-time=3000 --urgency=low 'kanshi: profile 'external-dp-1''";
      # }
    ];
  };

  # NOTE: temporal fix to make `kanshictl` accessible
  home.packages = [ pkgs.kanshi ];

  services.mako = {
    enable = true;
    settings.font = "JetBrainsMono Nerd Font 10";
  };
  programs.waybar.enable = true;
}
