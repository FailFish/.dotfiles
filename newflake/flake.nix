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

  outputs = { self, nixpkgs, darwin, home-manager, ... }@inputs:
    let
      # https://github.com/Misterio77/nix-starter-configs/issues/29#issuecomment-1516881655
      # instead of passing `overlays`
      inherit (self) outputs;
      mkNixos = { extraModules }: nixpkgs.lib.nixosSystem {
        modules = [
          inputs.home-manager.nixosModules.home-mananger
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.noah = import ./users/noah.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ] ++ extraModules;
        speicalArgs = { inherit inputs outputs; };
      };
      mkDarwin = { extraModules }: darwin.lib.darwinSystem {
        inherit inputs;
        modules = [
          inputs.home-manager.darinModules.home-mananger
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.noah = import ./users/noah.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ] ++ extraModules;
        specialArgs = { inherit outputs; };
      };
    in
    {
      # nixosModules = ...;
      # homeManagerModules = ...;

      nixosConfigurations = {
        ion = mkNixos [ ./machines/ion.nix ];

        vm-x86 = mkNixos [ ./machines/vm-x86.nix ];

        vm-aarch64 = mkNixos [ ./machines/vm-aarch64.nix ];

      };

      darwinConfigurations = {
        noahMBA = mkDarwin [ ./machines/noahMBA.nix ];

      };

      homeConfigurations =
        let
          system = "x86_64-linux";
          pkgs = import nixpkgs { inherit system; };
        in
        {
          blurry = home-manager.lib.homeManagerConfiguration {
            modules = [ ./users/blurry.nix ];
            inherit pkgs;
            extraSpecialArgs = { inherit inputs outputs; };
          };
        };
    };
}
