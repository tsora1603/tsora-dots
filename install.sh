#!/usr/bin/env bash
set -e 

sudo pacman -Syu \
    cliphist \
    feh \
    hyprland \
    imagemagick \
    inkscape \
    kitty \
    lact \
    libresprite \
    mediainfo \
    mpd \
    nwg-look \
    okular \
    onlyoffice \
    paru \
    parui \
    pascube \
    protonplus \
    qt6ct \
    rmpc \
    scour \
    stow \
    trash-cli \
    vlc \
    vscodium \
    wtype \
    yazi \
    zen-browser

paru -S \
    hydra-launcher-bin \
    hyprshutdown \
    noctalia-shell-git \
    otf-departure-mono-nerd \
    vtracer \
    xdg-desktop-portal-termfilechooser-hunkyburrito-git \
    zoom

sudo pacman -R alacritty micro

mkdir -p ~/Development
cd ~/Development
git clone https://github.com/tsora1603/pixora-icons.git
git clone https://github.com/tsora1603/tsora-dots.git
git clone https://aur.archlinux.org/pixora-icons-git.git

rm -rf ~/.config/fish
cd tsora-dots
stow --target="$HOME" dots/
git remote set-url origin git@github.com:tsora1603/tsora-dots.git

cd ../pixora-icons
git remote set-url origin git@github.com:tsora1603/pixora-icons.git
./install.sh

cd ../pixora-icons-git
git remote set-url origin ssh://aur@aur.archlinux.org/pixora-icons-git.git

echo 'UUID=48D2B025D2B01960                     /mnt/extrastuff1   ntfs3   nofail,x-systemd.automount,noatime,uid=1000,gid=1000 0 0
UUID=32FFB061010241EF                             /mnt/extrastuff2   ntfs3   nofail,x-systemd.automount,noatime,uid=1000,gid=1000 0 0' | sudo tee -a /etc/fstab

systemctl --user enable mpd
systemctl --user start mpd

echo "Rebooting in 5..."
sleep 1s
echo "4..."
sleep 1s 
echo "3..."
sleep 1s 
echo "2..."
sleep 1s 
echo "1..."
sleep 1s

reboot
