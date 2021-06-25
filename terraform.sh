#!/bin/bash

# sudo pacman -S --needed nvidia-lts reflector pkgfile pacman-contrib xclip zip unzip cmake python python-pip base-devel tmux htop curl intel-ucode sudo firefox alacritty zathura-pdf-mupdf tldr tree fish fzf ripgrep fd exa bat procs xorg xorg-xinit bspwm picom sxhkd tint2 rofi feh lesspipe

ln -sf $(pwd)/.bashrc $HOME/.bashrc
ln -sf $(pwd)/.vimrc $HOME/.vimrc
ln -sf $(pwd)/.tmux.conf $HOME/.tmux.conf
ln -sf $(pwd)/.inputrc $HOME/.inputrc

ln -s $(pwd)/.config/alacritty $HOME/.config/alacritty
ln -s $(pwd)/.config/bspwm $HOME/.config/bspwm
ln -s $(pwd)/.config/rofi $HOME/.config/rofi
ln -s $(pwd)/.config/sxhkd $HOME/.config/sxhkd
ln -s $(pwd)/.config/tint2 $HOME/.config/tint2
ln -s $(pwd)/.config/zathura $HOME/.config/zathura
