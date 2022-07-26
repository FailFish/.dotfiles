#!/bin/bash

PKGS=(
    # SYSTEM
    # sudo
    # base-devel
    # networkmanager

    # Pacman related
    reflector
    pkgfile
    pkgconf
    pacman-contrib

    # CLI Utilites
    git
    vim
    neovim
    openssh
    wget
    curl
    rust
    python
    python-pip
    gdb
    man-pages
    man-db
    shellcheck
    cmake
    tmux
    htop
    lshw
    tldr
    tree
    bash-completion
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
    scrot
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
    ttf-hack

    # Korean
    fcitx5-im
    fcitx5-hangul

)

PKGS_HOST=(
    # Audio
    pulseaudio
    pulseaudio-alsa
    pavucontrol
    sof-firmware

    # Bluetooth
    bluez
    bluez-utils
    blueman
    pulseaudio-bluetooth
    # systemctl enable bluetooth.service

    # Messenger
    discord

    # documentation
    obsidian

    # Host Linux Only
    docker
    docker-compose
    vlc
    # nvidia
    # intel-ucode
    # dosfstools
    # efibootmgr
    # os-prober
    # mtools

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
    cd $HOME
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si
    cd $HOME/.dotfiles
fi

echo
echo "Installing AUR packages"
echo

AURS=(
    nerd-fonts-inter
    otf-nerd-fonts-monacob-mono
    nerd-fonts-roboto-mono
    nerd-fonts-fira-code

    # Documentation
    hoffice
    zotero
    flow-pomodoro
    pilorama
)

AURS_HOST=(
    zoom
)
for AUR in "${AURS[@]}"; do
    echo "INSTALLING: ${AUR}"
    paru -S "$AUR" --noconfirm --needed
done

ln -sf $(pwd)/.bashrc $HOME/.bashrc
ln -sf $(pwd)/.vimrc $HOME/.vimrc
ln -sf $(pwd)/.tmux.conf $HOME/.tmux.conf
ln -sf $(pwd)/.inputrc $HOME/.inputrc
ln -sf $(pwd)/.xinitrc $HOME/.xinitrc

mkdir $HOME/.config
ln -sf $(pwd)/.config/alacritty $HOME/.config/alacritty
ln -sf $(pwd)/.config/bspwm $HOME/.config/bspwm
ln -sf $(pwd)/.config/rofi $HOME/.config/rofi
ln -sf $(pwd)/.config/sxhkd $HOME/.config/sxhkd
ln -sf $(pwd)/.config/tint2 $HOME/.config/tint2
ln -sf $(pwd)/.config/zathura $HOME/.config/zathura
ln -sf $(pwd)/.config/nvim $HOME/.config/nvim
