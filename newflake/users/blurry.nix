{ inputs, ... }: {
  imports = [
    ./common/home.nix
  ];
  home = {
    username = "blurry";
    homeDirectory = "/home/blurry";
  };
  targets.genericLinux.enable = true;
}
