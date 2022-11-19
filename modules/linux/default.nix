# linux specific system settings
{ config, pkgs, ... }:
let
  user = "blurry";
in {
  imports = [
  ];

  # user-specific setting (for home-manager)
  users.users.${user} = {
    name = "${user}";
    home = "/home/${user}";
    shell = pkgs.bashInteractive;
  };

  # A list of permissible shells
  environment.shells = [ pkgs.bashInteractive ];

  # system-wide default programs
  # programs.man.enable = true;
  programs.vim.enable = true;
  programs.vim.enableSensible = true;

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      # https://nixos.wiki/wiki/Fonts
      (nerdfonts.override { fonts = [ "RobotoMono" "JetBrainsMono" ]; })
    ];
  };
}
