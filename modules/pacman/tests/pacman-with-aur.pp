# pacman class with default settings
# this only configures pacman.conf with core, extra and community repositories
# and also enables AUR support
# pacman.conf will be comatible/mimics default pacman.conf on Arch Linux
class { 'pacman':
  manage_aur => true,
}
