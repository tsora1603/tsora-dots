#!/usr/bin/env bash
set -e 

sudo pacman -Syu \
    imagemagick \
    inkscape \
    kitty \
    lact \
    libresprite \
    mpd \
    nwg-look \
    okular \
    onlyoffice \
    paru \
    pascube \
    protonplus \
    rmpc \
    scour \
    stow \
    vlc \
    vscodium \
    yazi \
    zen-browser

paru -S hydra-launcher-bin vtracer zoom

mkdir -p Development
cd Development
git clone git@github.com:tsora1603/pixora-icons.git
git clone ssh://aur@aur.archlinux.org/pixora-icons-git.git
git clone git@github.com:tsora1603/tsora-dots.git

cd tsora-dots
stow --target="$HOME" dots/
sudo stow --target=/etc etc/

cd ../pixora-icons
./install.sh
