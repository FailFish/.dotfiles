# Nix-powered

## Darwin

```sh
# initial setup
sudo nix --extra-experimental-features "nix-command flakes" run nix-darwin/master#darwin-rebuild -- switch --flake ~/.dotfiles/flake.nix

# updates
sudo darwin-rebuild switch --flake ~/.dotfiles/flake.nix
```

## Home-manager standalone

```sh
# install home-manager
nix run home-manager/master -- init --switch
# update
home-manager switch --flake .#<username@hostname>
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
