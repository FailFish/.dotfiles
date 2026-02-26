{
  description = "Rust development shell (oxalica/rust-overlay)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, rust-overlay, ... }:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ (import rust-overlay) ];
          };
          # rustVersion = pkgs.rust-bin.stable."1.65.0".default;
          rustVersion = pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
        in
        {
          default = pkgs.mkShell {
            buildInputs = [
              (rustVersion.override { extensions = [ "rust-src" "rustc-dev" "llvm-tools-preview" ]; })
            ];
          };
        });

      # Integrate Cargo.toml into nix — uncomment to build a package
      # packages = forAllSystems (system:
      #   let
      #     pkgs = import nixpkgs {
      #       inherit system;
      #       overlays = [ (import rust-overlay) ];
      #     };
      #     rustVersion = pkgs.rust-bin.stable.latest.default;
      #     rustPlatform = pkgs.makeRustPlatform {
      #       cargo = rustVersion;
      #       rustc = rustVersion;
      #     };
      #   in
      #   {
      #     default = rustPlatform.buildRustPackage {
      #       pname = "my-project";
      #       version = "0.1.0";
      #       src = ./.;
      #       cargoLock.lockFile = ./Cargo.lock;
      #     };
      #   });
    };
}
