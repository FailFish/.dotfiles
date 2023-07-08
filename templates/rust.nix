{
  description = "A simple Rust flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    fenix.url = "github:nix-community/fenix/monthly";
    fenix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, fenix, ... }@inputs:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });

    in
    {
      devShells = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
          fenixpkgs = fenix.packages.${system};

          # latest complete profile
          rustLatest = fenixpkgs.latest;

          # https://rust-lang.github.io/rustup/concepts/toolchains.html
          rustFromToml = fenixpkgs.fromToolchainFile {
            file = ./rust-toolchain.toml;
            sha256 = pkgs.lib.fakeSha256;
          };

          # cherry-pick from one channel
          rustCustom = fenixpkgs.complete.withComponents [
            "cargo"
            "rustc"
            "rust-std"
            "rustfmt"
            "clippy"
            "miri"
          ];

          # cherry-pick with different target triple
          rustCross = with fenixpkgs;
            combine [
              minimal.cargo
              minimal.rustc
              default.rustfmt
              default.clippy
              # targets.wasm32-unknown-unknown.latest.rust-std
              # targets.aarch64-apple-darwin.latest.rust-std
              # targets.x86_64-unknown-linux-gnu.latest.rust-std
            ];

          rust = rustCustom; # or rustCustom or rustFromToml
        in
        {
          default = pkgs.mkShell {
            buildInputs = [
              rust
            ];

            # For Rust language server and rust-analyzer
            RUST_SRC_PATH = "${fenix.complete.rust-src}/lib/rustlib/src/rust/library}";

            # Point bindgen to where the clang library would be
            LIBCLANG_PATH = "${pkgs.libclang.lib}/lib";
            # Make clang aware of a few headers (stdbool.h, wchar.h)
            # BINDGEN_EXTRA_CLANG_ARGS = with pkgs; ''
            #   -isystem ${llvmPackages.libclang.lib}/lib/clang/${lib.getVersion clang}/include
            #   -isystem ${llvmPackages.libclang.out}/lib/clang/${lib.getVersion clang}/include
            #   -isystem ${glibc.dev}/include
            # '';
            # LLVM_CONFIG_PATH="${pkgs.llvmPackages.bintools}/bin/llvm-config";
          };
        });
    };
}
