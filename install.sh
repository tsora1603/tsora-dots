#!/usr/bin/env bash
set -e 

# installing pacman packages
sudo pacman -Syu \
    dolphin \
    cachyos-gaming-meta \
    cachyos-gaming-applications \
    cliphist \
    curl \
    equibop \
    eza \
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
    lazygit \
    libresprite \
    mediainfo \
    mpd \
    mpd-mpris \
    nwg-look \
    onlyoffice \
    paru \
    pascube \
    playerctl \
    protonplus \
    python-lxml \
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
    wf-recorder \
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
    parui \
    python-pywalfox \
    qt6ct-kde \
    vtracer \
    xdg-desktop-portal-termfilechooser-hunkyburrito-git \
    zoom

# debloat
sudo pacman -R alacritty micro

# setting up Development directory with repos
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

# setting up fstab
echo 'UUID=48D2B025D2B01960                     /mnt/extrastuff1   ntfs3   nofail,x-systemd.automount,noatime,uid=1000,gid=1000 0 0
UUID=32FFB061010241EF                             /mnt/extrastuff2   ntfs3   nofail,x-systemd.automount,noatime,uid=1000,gid=1000 0 0' | sudo tee -a /etc/fstab

# systemd services
systemctl --user enable mpd
systemctl --user enable mpd-mpris
systemctl --user enable ssh-agent
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
sleep 1
echo "4..."
sleep 1
echo "3..."
sleep 1
echo "2..."
sleep 1
echo "1..."
sleep 1

sudo reboot
