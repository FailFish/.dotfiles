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
}
