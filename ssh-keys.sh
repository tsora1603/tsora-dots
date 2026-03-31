#!/usr/bin/env bash
set -e

mkdir -p ~/.ssh
cp -r /mnt/extrastuff2/.ssh-backup/. ~/.ssh/

chmod 700 ~/.ssh
chmod 600 ~/.ssh/aur ~/.ssh/github
chmod 644 ~/.ssh/aur.pub ~/.ssh/github.pub

echo "ssh keys in place!"
