{
  description = "C/C++ environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils, ... }@inputs:
    utils.lib.eachDefaultSystem (
      system:
      let
        p = import nixpkgs {
          inherit system;
        };
        llvm = p.llvmPackages_latest;
        pc = import nixpkgs {
          inherit system;
          crossSystem = nixpkgs.lib.systems.examples.aarch64-multiplatform // { useLLVM = true; };
        };

        # simple script which replaces the functionality of make
        # it works with <math.h> and includes debugging symbols by default
        # it will be updated as per needs

        # arguments: outfile
        # basic usage example: mk main [flags]
        mymake = p.writeShellScriptBin "mk" ''
          if [ -f "$1.c" ]; then
            i="$1.c"
            c=$CC
          else
            i="$1.cpp"
            c=$CXX
          fi
          o=$1
          shift
          $c -ggdb $i -o $o -lm -Wall $@
        '';
      in
      {
        devShells = {
          default = p.mkShell.override { stdenv = p.clangStdenv; } rec {
            packages = with p; [
              # builder
              gnumake
              cmake
              bear

              # debugger
              llvm.lldb
              gdb

              # fix headers not found
              clang-tools
              # stdlib for cpp
              llvm.libcxx
              llvm.bintools

              # LSP and compiler
              # llvm.libstdcxxClang

              # other tools
              cppcheck
              llvm.libllvm
              valgrind

              # custom make
              mymake
            ];
            name = "C";
          };

          # pc.buildPackages.clang; x86-64-linux -> aarch64-linux
          # pc.clang; aarch64-linux -> aarch64-linux
          linux-cross = pc.mkShell rec {
            # This decides CC, but still CC will not be aarch64-*-cc
            depsBuildBuild = [ pc.buildPackages.clangStdenv.cc ];
            # depsBuildBuild = [ pc.buildPackages.stdenv.cc ];

            nativeBuildInputs = with pc.buildPackages; [
              # linux compatibility
              flex
              bison
              bc
              ncurses
              openssl
              pkgconfig

              # pkgsCross.aarch64-multiplatform.clang

              # custom make
              mymake
            ];
            buildInputs = with pc; [ zlib ];
            # CLANGD_FLAGS = "--query-driver=aarch64-unknown-linux-gnu-gcc";

            # Issue: `clang` causes `arm_neon.h` not found error, but aarch64-*-clang does not
            # Linux should be built with
            # make -j$(nproc) ARCH=arm64 LLVM=1 CC=aarch64-unknown-linux-gnu-clang
          };
        };
      }
    );
}
