# aur class with default settings
# this only configures pacman class with AUR support and installs package from
# AUR
# pacman.conf will be comatible/mimics default pacman.conf on Arch Linux
class { 'pacman':
  manage_aur => true,
}

pacman::aur { 'cowsay-futurama': }
