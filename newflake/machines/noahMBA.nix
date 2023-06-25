{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
  ];

  networking.hostName = "noahMBA";

  # https://github.com/nix-community/home-manager/issues/2942#issuecomment-1378627909
  nixpkgs = {
    # vscode requires unfree
    config.allowUnfree = true;
    # unsupported packages in aarch64 sometimes work well
    config.allowUnsupportedSystem = true;
  };
}
