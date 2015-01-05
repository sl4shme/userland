# mirrorlist class with default settings and ranked 4 mirrors by speed
# pacman.conf will be comatible/mimics default pacman.conf on Arch Linux

# This is only here as an example. If you do not use main 'pacman' class
# then this pacman class is not needed.
class { 'pacman':
  mirrorlist_manage => false,
}

class { 'pacman::mirrorlist':
  rank => 4,
}
