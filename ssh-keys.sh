#!/usr/bin/env bash
set -e

mkdir -p ~/.ssh
cp -r /mnt/extrastuff2/.ssh-backup $HOME/.ssh

echo "ssh keys in place!"
