{ inputs, ... }:
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

  services.mako = {
    enable = true;
    font = "JetBrainsMono Nerd Font 10";
  };
  programs.waybar.enable = true;
}
