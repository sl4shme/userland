#!/bin/bash
mkdir /tmp/insYaourt
cd /tmp/insYaourt
pacman-db-upgrade
pacman -Sy
sudo pacman -S --noconfirm curl base-devel bc
curl -O https://aur.archlinux.org/packages/pa/package-query/package-query.tar.gz
tar zxvf package-query.tar.gz
cd package-query
makepkg -si --noconfirm
cd ..
curl -O https://aur.archlinux.org/packages/ya/yaourt/yaourt.tar.gz
tar zxvf yaourt.tar.gz
cd yaourt
makepkg -si --noconfirm

