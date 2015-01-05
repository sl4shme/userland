# pacman class with default settings and 1 custom via repo class
# this only configures pacman.conf with default repositories and adds custom
# repository via pacman::repo class.
# pacman.conf will be comatible/mimics default pacman.conf on Arch Linux

class { 'pacman':
}

pacman::repo { 'repo-ck':
  server => 'http://repo-ck.com/$arch',
  order  => '50',
}
