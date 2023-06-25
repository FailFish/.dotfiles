{
  description = "Noh's CornFlakes";

  inputs = {
    # https://nixos.wiki/wiki/Nix_channels
    # https://discourse.nixos.org/t/differences-between-nix-channels/13998
    nixpkgs.url = "github:nixos/nixpkgs";
    nixpkgs-stable.url = "github:nixos/nixpkgs/release-23.05";
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      # this line makes darwin uses same version of `nixpkgs` with nixpkgs flake.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # `outputs` schema is described in the https://github.com/NixOS/nix/blob/master/src/nix/flake.cc in CmdFlakeCheck.
  outputs = { self, nixpkgs, darwin, home-manager, ... }@inputs:
    let
      inherit (nixpkgs.lib.strings) hasInfix;
      inherit (nixpkgs.lib) nixosSystem;
      inherit (darwin.lib) darwinSystem;
      mkSystem =
      { hostname
      , user ? "noah"
      , system ? "aarch64-darwin"
      , extraModules ? []
      , homeModules ? import ./modules/common/home.nix
      , ...}:
        let
          linuxOr = a: b: if (hasInfix "linux" system) then a else b;
          systemFn = linuxOr nixosSystem darwinSystem;
          homeManagerModules = linuxOr home-manager.nixosModules.home-manager home-manager.darwinModules.home-manager;
        in systemFn {
          inherit system;
          modules = [
          { networking.hostName = hostname; }
          {
            # https://github.com/nix-community/home-manager/issues/2942#issuecomment-1378627909
            nixpkgs = {
              # vscode requires unfree
              config.allowUnfree = true;
              # unsupported packages in aarch64 sometimes work well
              config.allowUnsupportedSystem = true;
            };
          }
          homeManagerModules
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${user} = homeModules;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
          ] ++ extraModules;
        };
    in {

    darwinConfigurations = {
      noahMBA = mkSystem {
        hostname = "noahMBA";
        system = "aarch64-darwin";
        extraModules = [ ./modules/darwin ];
        # inputs = { inherit nixpkgs darwin home-manager; };
      };
    };

    # standalone home-manager for non-nixos/darwin
    homeConfigurations =
      let
        system = "x86_64-linux";
        pkgs = import nixpkgs { inherit system; };
        user = "blurry";
      in {
        ${user} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            ./modules/common/home.nix
            ({ ... }: {
              nix = {
                package = pkgs.nix; # this is not default in home-manager only
                extraOptions = ''
                  experimental-features = nix-command flakes
                '';
              };
              programs.nix-index.enable = true;
              home = {
                username = "${user}";
                homeDirectory = "/home/${user}";
              };
              targets.genericLinux.enable = true;
            })
          ];
        };
      };
  };
}
