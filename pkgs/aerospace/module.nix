{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.aerospace;
  tomlFormat = pkgs.formats.toml { };
in
{
  options = {
    programs.aerospace = {
      enable = mkEnableOption "an i3-like window manager for macOS";

      package = mkOption {
        type = types.package;
        default = pkgs.callPackage ./pkg.nix { };
        description = "The aerospace package to install.";
      };

      settings = mkOption {
        inherit (tomlFormat) type;
        default = { };
        description = "Configuration for aerospace.";
      };

      enableJankyBorders = mkOption {
        type = types.bool;
        default = true;
        description = "Enable the JankyBorders package alongside aerospace.";
      };

      jankybordersPackage = mkOption {
        type = types.package;
        default = pkgs.jankyborders;
        description = "The JankyBorders package to install.";
      };

      aerospaceAppPath = mkOption {
        type = types.str;
        default = "${cfg.package}/Applications/AeroSpace.app";
        description = "Path to the Aerospace.app bundle.";
      };

      runOnStartup = mkOption {
        type = types.bool;
        default = true;
        description = "Run AeroSpace.app on startup.";
      };
    };
  };

  config = mkIf cfg.enable {
    # home.packages = [ cfg.package ]
    environment.systemPackages = [ cfg.package ]
      ++ lib.optional cfg.enableJankyBorders cfg.jankybordersPackage;

    environment.etc."aerospace.toml" = mkIf (cfg.settings != { }) {
      source = tomlFormat.generate "config" cfg.settings;
    };

    launchd.user.agents.aerospace.serviceConfig = {
      ProgramArguments = [ "${cfg.package}/Applications/AeroSpace.app/Contents/MacOS/AeroSpace" ]
        ++ optionals (cfg.settings != { }) [ "--config-path" "/etc/aerospace.toml" ];

      KeepAlive = true;
      RunAtLoad = true;
      EnvironmentVariables = {
        PATH = "${cfg.package}/bin:${config.environment.systemPath}";
      };
      StandardOutPath = "/tmp/aerospace.log";
      StandardErrorPath = "/tmp/aerospace.err";
    };
  };
}
