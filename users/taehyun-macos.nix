{ inputs, config, ... }: {
  imports = [
    ./common/home.nix
  ];

  home.username = "taehyun";
  home.homeDirectory = "/Users/taehyun";
}
