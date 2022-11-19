{ config, pkgs, lib, ...}:

let
  isDarwinArm64 = pkgs.stdenvNoCC.isDarwin && pkgs.stdenvNoCC.isAarch64;
in {
  homebrew = {
    # enabling does not install homebrew!
    enable = true;
    taps = [
      "homebrew/cask"
      "homebrew/cask-versions"
    ];
    casks = [
      "obsidian"
      "zoom"
      "discord"
      "aldente"
      "spotify"
      "iterm2"
      "skim"
      "vmware-fusion-tech-preview" # from cask-versions
      "zotero"
    ];
    masApps = {
      "Slack" = 803453959;
      "Mattermost" = 1614666244;
    };
    onActivation.cleanup = "zap";
  };
}
