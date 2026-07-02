{ config, pkgs, lib, ...}:

let
  isDarwinArm64 = pkgs.stdenvNoCC.isDarwin && pkgs.stdenvNoCC.isAarch64;
in {
  homebrew = {
    # enabling does not install homebrew!
    enable = true;
    enableFishIntegration = true;
    taps = [
    ];
    casks = [
      "obsidian"
      "zoom"
      "discord"
      "aldente"
      "spotify"
      "iterm2"
      "zotero"
      "firefox"
      "google-chrome"
      "zerotier-one"
      "betterdisplay"
    ];
    masApps = {
      "Slack" = 803453959;
      "Mattermost" = 1614666244;
      "Kakaotalk" = 869223134;
    };
    onActivation.cleanup = "zap";
  };
}
