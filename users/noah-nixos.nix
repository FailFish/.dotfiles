{ inputs, ... }:
{ inputs, pkgs, ... }:
let
  rootdir = ./..;
  cfgdir = rootdir + "/.config";
in
{
  imports = [
    ./common/home.nix
  ];

  # NixOS-only
  xdg.configFile."hypr".source = cfgdir + "/hypr";
  xdg.configFile."waybar".source = cfgdir + "/waybar";

  i18n = {
    inputMethod = {
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
    profiles = {
      default = {
        outputs = [
          {
            # check man 5 kanshi
            criteria = "eDP-1";
            status = "enable";
          }
        ];
      };

      external-dp = {
        outputs = [
          {
            criteria = "DP-1";
            status = "enable";
            scale = 1.5;
          }
          {
            criteria = "eDP-1";
            status = "disable";
          }
        ];
        exec = "${pkgs.libnotify}/bin/notify-send --expire-time=3000 --urgency=low 'kanshi: profile 'external-dp-1''";
      };
    };
  };

  # NOTE: temporal fix to make `kanshictl` accessible
  home.packages = [ pkgs.kanshi ];

  services.mako = {
    enable = true;
    font = "JetBrainsMono Nerd Font 10";
  };
  programs.waybar.enable = true;
}
