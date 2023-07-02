{ inputs, ... }: {
  imports = [
    ./common/home.nix
  ];
  nix = {
    package = pkgs.nix; # this is not default in home-manager only
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  home = {
    username = "blurry";
    homeDirectory = "/home/blurry";
  };
  targets.genericLinux.enable = true;
}
