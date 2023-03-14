## Nix-powered
```
repo
- flake.nix
- modules/
  - darwin/ : macos
    - default.nix : system-wide darwin-nix config
    - packages.nix : a list of darwin-only packages
  - linux/ : nixos
  - common/ : platform-independent
    - home.nix : user-specific home-manager config
    - packages.nix : a list of common packages
```


## Darwin

```sh
# initial setup
nix --experimental-features "nix-command flakes" build ".#darwinConfigurations.noahMBA.system"
./result/sw/bin/darwin-rebuild switch --flake ~/.nixpkgs

# updates
nix build .#darwinConfigurations.noahMBA.system --show-trace --verbose
./result/sw/bin/darwin-rebuild switch --flake .
```

## Home-manager standalone

```sh
# initial setup
nix --experimental-features "nix-command flakes" build ".#homeConfigurations.blurry.activationPackage"
./result/activate

# updates
home-manager switch --flake .#homeConfigurations.blurry
# or
home-manager switch --flake .#blurry
```

## NixOS

I haven't tested this.
```sh
nix --experimental-features "nix-command flakes" build ".#nixosConfigurations.noahNixos.config.system.build.toplevel"
./result/bin/switch-to-configuration switch
# or if you want to edit boot entry
sudo nixos-rebuild switch --flake ".#noahNixos"
# or if you want to install from scratch
sudo nixos-install --flake github:FailFish/.dotfiles#noahNixos
```

## Plan

- [ ]: VM support
- [ ]: devShell setting

## Font

System/UI: Inter Nerd Font

## Issue

- bspwm: have an issue with firefox[:the post on github issue](https://github.com/baskerville/bspwm/issues/1015)

Extra
---
- elementary-planner
  put `database.db` at `~/.local/share/com.github.alainm23.planner/database.db`
  or `~/.var/app/com.github.alainm23.planner/data/com.github.alainm23.planner/database.db` in the case of flatpak
