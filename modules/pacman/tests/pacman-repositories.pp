# pacman class with default settings
# this only configures pacman.conf with specific repositories
# pacman.conf will be comatible/mimics default pacman.conf on Arch Linux
$repositories = {
  'core'      => { order  => '10' },
  'extra'     => { order  => '20' },
  'community' => { order  => '30' },
  'multilib'  => { order  => '40' },
  'repo-ck'   => { server => 'http://repo-ck.com/$arch', order   => '50' },
}

class { 'pacman':
  repositories => $repositories,
}
