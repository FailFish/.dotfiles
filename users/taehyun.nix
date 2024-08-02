{ inputs, pkgs, ... }: {
  imports = [
    ./common/home.nix
  ];
  nix = {
    package = pkgs.nixFlakes; # this is not default in home-manager only
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  home = {
    username = "taehyun";
    homeDirectory = "/home/taehyun";
  };
  targets.genericLinux.enable = true;
}
