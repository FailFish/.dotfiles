#!/bin/bash

sudo pacman -S --needed nvidia-lts reflector pkgfile pacman-contrib xclip zip unzip cmake python python-pip base-devel tmux htop wget curl intel-ucode sudo firefox alacritty zathura-pdf-mupdf tldr tree fish fzf ripgrep fd exa bat procs xorg xorg-xinit bspwm picom sxhkd tint2 rofi feh redshift lesspipe adobe-source-han-sans-kr-fonts adobe-source-han-serif-kr-fonts ttf-fira-code ttf-dejavu bluez bluez-utils openssh nnn dolphin qt5ct breeze-icons lxappearance-gtk3 papirus-icon-theme fcitx5-im fcitx5-hangul inetutils

if ! command -v paru &> /dev/null
then
    echo "paru must be installed first!"
    exit
fi
paru -S nerd-fonts-inter otf-nerd-fonts-monacob-mono nerd-fonts-roboto-mono nerd-fonts-fira-code # elementary-planner

systemctl enable bluetooth.service

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
