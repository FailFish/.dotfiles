#!/bin/bash

PKGS=(
	# SYSTEM
	# sudo
	# base-devel

	# Pacman related
	reflector
	pkgfile
	pacman-contrib

	# CLI Utilites
	vim
	neovim
	openssh
	wget
	curl
	rust
	python
	python-pip
	man-pages
	man-db
	shellcheck
	cmake
	tmux
	htop
	tldr
	tree
	fish
	fzf
	ripgrep
	fd
	exa
	bat
	procs
	lesspipe
	nnn
	inetutils
	zip
	unzip

	# GUI
	xorg
	xorg-xinit
	bspwm
	sxhkd
	picom
	tint2
	feh
	redshift
	rofi
	alacritty
	xclip
	firefox
	zathura-pdf-mupdf
	dolphin
	qt5ct

	# Appearance (Fonts & Icons)
	breeze-icons
	lxappearance-gtk3
	papirus-icon-theme
	adobe-source-han-sans-kr-fonts
	adobe-source-han-serif-kr-fonts
	ttf-fira-code
	ttf-dejavu

	# Korean
	fcitx5-im
	fcitx5-hangul

)

PKGS_HOST=(
	# Bluetooth
	bluez
	bluez-utils
	blueman
	pulseaudio-bluetooth
	# systemctl enable bluetooth.service

	# Host Linux Only
	nvidia-lts
	intel-ucode
	docker
	docker-compose
	vlc

	# Laptop Only
	tlp
	# systemctl enable tlp
)


for PKG in "${PKGS[@]}"; do
	echo "INSTALLING: ${PKG}"
	sudo pacman -S "$PKG" --noconfirm --needed
done

## AUR packages
if ! command -v paru &> /dev/null
then
	echo "Installing paru ..."
	git clone https://aur.archlinux.org/paru.git
	cd paru
	mkepkg -si
fi

echo
echo "Installing AUR packages"
echo

AURS=(
	nerd-fonts-inter
	otf-nerd-fonts-monacob-mono
	nerd-fonts-roboto-mono
	nerd-fonts-fira-code
	# elementary-planner
)

AURS_HOST=(
	zoom
)
for AUR in "${AURS[@]}"; do
	echo "INSTALLING: ${AUR}"
	sudo paru -S "$AUR" --noconfirm --needed
done

ln -sf $(pwd)/.bashrc $HOME/.bashrc
ln -sf $(pwd)/.vimrc $HOME/.vimrc
ln -sf $(pwd)/.tmux.conf $HOME/.tmux.conf
ln -sf $(pwd)/.inputrc $HOME/.inputrc

mkdir $HOME/.config
ln -s $(pwd)/.config/alacritty $HOME/.config/alacritty
ln -s $(pwd)/.config/bspwm $HOME/.config/bspwm
ln -s $(pwd)/.config/rofi $HOME/.config/rofi
ln -s $(pwd)/.config/sxhkd $HOME/.config/sxhkd
ln -s $(pwd)/.config/tint2 $HOME/.config/tint2
ln -s $(pwd)/.config/zathura $HOME/.config/zathura
ln -s $(pwd)/.config/nvim $HOME/.config/nvim
