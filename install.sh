#!/usr/bin/env bash
set -e 

# installing pacman packages
sudo pacman -Syu \
    cachyos-gaming-meta \
    cachyos-gaming-applications \
    cliphist \
    curl \
    equibop \
    feh \
    ffmpeg \
    firefoxpwa \
    greetd \
    grim \
    hyprland \
    imagemagick \
    inkscape \
    kitty \
    lact \
    libresprite \
    mediainfo \
    mpd \
    mpd-mpris \
    nwg-look \
    okular \
    onlyoffice \
    paru \
    parui \
    pascube \
    protonplus \
    qt6ct \
    resvg \
    rmpc \
    scour \
    slurp \
    stow \
    swappy \
    tesseract \
    tesseract-data-eng \
    tesseract-data-por \
    translate-shell \
    trash-cli \
    vlc \
    vscodium \
    wl-clipboard \
    wtype \
    yazi \
    zbar \
    zen-browser

# installing AUR packages
paru -S \
    hydra-launcher-bin \
    hyprshutdown \
    millennium \
    noctalia-shell-git \
    otf-departure-mono-nerd \
    vtracer \
    wl-screenrec-git \
    xdg-desktop-portal-termfilechooser-hunkyburrito-git \
    zoom

# debloat
sudo pacman -R alacritty micro

# setting up Development folder with repos
mkdir -p ~/Development
cd ~/Development
git clone https://github.com/tsora1603/pixora-icons.git
git clone https://github.com/tsora1603/tsora-dots.git
git clone https://aur.archlinux.org/pixora-icons-git.git

# removing preinstalled fish config
rm -rf ~/.config/fish

# setting up dotfiles
cd tsora-dots
stow --target="$HOME" dots/
sudo rm -f /etc/greetd/config.toml
sudo stow --target=/etc etc/
git remote set-url origin git@github.com:tsora1603/tsora-dots.git

# setting up pixora-icons git and installing
cd ../pixora-icons
git remote set-url origin git@github.com:tsora1603/pixora-icons.git
./install.sh

# setting up pixora-icons-git (AUR) 
cd ../pixora-icons-git
git remote set-url origin ssh://aur@aur.archlinux.org/pixora-icons-git.git

# setting up fstab
echo 'UUID=48D2B025D2B01960                     /mnt/extrastuff1   ntfs3   nofail,x-systemd.automount,noatime,uid=1000,gid=1000 0 0
UUID=32FFB061010241EF                             /mnt/extrastuff2   ntfs3   nofail,x-systemd.automount,noatime,uid=1000,gid=1000 0 0' | sudo tee -a /etc/fstab

# systemd services
systemctl --user enable mpd
systemctl --user enable mpd-mpris
sudo systemctl enable greetd

# firefoxpwa runtime
firefoxpwa runtime install

# steam stuff
mkdir -p ~/.local/share/Steam

if [ -d ~/.steam/steam ] && [ ! -L ~/.steam/steam ]; then
    echo "Fixing broken Steam symlink..."
    rm -rf ~/.steam/steam
    ln -s ~/.local/share/Steam ~/.steam/steam
fi

# finishing
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

sudo reboot
