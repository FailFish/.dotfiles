#!/bin/bash

nix build .#darwinConfigurations.noahMBA.system --show-trace --verbose
./result/sw/bin/darwin-rebuild switch --flake .
