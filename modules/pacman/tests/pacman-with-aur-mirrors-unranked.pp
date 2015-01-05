# pacman class with default settings
# this only configures pacman.conf with core, extra and community repositories
# and also enables AUR support and downloads latest mirrorlist. Does not rank
# mirrors.
# pacman.conf will be comatible/mimics default pacman.conf on Arch Linux
class { 'pacman':
  manage_aur        => true,
  mirrorlist_manage => true,
}
