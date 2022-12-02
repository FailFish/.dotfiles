{
  description = "flake template for rust development";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };


  outputs = { self, nixpkgs, flake-utils, rust-overlay, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs { inherit system overlays; };
        # rustVersion = pkgs.rust-bin.stable."1.65.0".default;
        rustVersion = pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
      in {
        devShell = pkgs.mkShell {
          buildInputs =
            [ (rustVersion.override { extensions = [ "rust-src" "rustc-dev" "llvm-tools-preview" ]; }) ];
        };
      });

  # Integrate Cargo.toml into nix
  # outputs = { self, nixpkgs, flake-utils, rust-overlay, ... }:
  #   flake-utils.lib.eachDefaultSystem (system:
  #     let
  #       overlays = [ (import rust-overlay) ];
  #       pkgs = import nixpkgs { inherit system overlays; };
  #       rustVersion = pkgs.rust-bin.stable.latest.default;
  #       rustPlatform = pkgs.makeRustPlatform {
  #         cargo = rustVersion;
  #         rustc = rustVersion;
  #       };
  #       myRustBuild = rustPlatform.buildRustPackage {
  #         pname =
  #           "rust_nix_blog"; # make this what ever your cargo.toml package.name is
  #         version = "0.1.0";
  #         src = ./.; # the folder with the cargo.toml
  #         cargoLock.lockFile = ./Cargo.lock;
  #       };
  #     in {
  #       defaultPackage = myRustBuild;
  #       devShell = pkgs.mkShell {
  #         buildInputs =
  #           [ (rustVersion.override { extensions = [ "rust-src" ]; }) ];
  #       };
  #     });
}
