# Definition pacman::repo
#
# This lets you configure repositories for pacman. See man pacman.conf for more
# information on how definitions work. Defining pacman::repo will result in
# entry in pacman.conf file. This class should be managed via main pacman class
# and should not be included separately.
#
# Parameters:
#
#   [*server*]      - specify server url (e.g. "http://repo.archlinux.fr/$arch")
#     (string|undef)  You can skip this if you want to enable official
#                     repository and use mirrorlist.
#                     [default: "mirrorlist"]
#   [*sig_level*]   - specify signature verification level for repository
#     (string|undef)  [default: undef]
#   [*order*]       - specify order for repository (see man pacman.conf for more
#     (numeric)       information). Number must be in range of [1..99].
#                     [default: 99]
#
# Default repositories:
#
# These default repositories are defined in pacman class if you do not specify
# $repositories parameter manually. This is useful to know as order of defined
# repositories matter for pacman (see man pacman.conf for more information)
#
#     $repositories = {
#       'core'  => {     order => 10, },
#       'extra' => {     order => 20, },
#       'community' => { order => 30, },
#     }
#
# Usage:
#
#       class { 'pacman': }
#
#       pacman::repo { 'repo-ck':
#         server => 'http://repo-ck.com/$arck',
#         order  => 50,
#       }
#
define pacman::repo(
  $server          = 'mirrorlist',
  $sig_level       = undef,
  $order           = 99,
  $pacman_config   = $pacman::params::pacman_config,
  $pacman_config_d = $pacman::params::pacman_config_d,
) {
  # valiation
  validate_string($server)
  if $sig_level != undef {
    validate_string($sig_level)
  }
  if !is_numeric($order) or $order < 1 or $order > 99 {
    fail("Order must be a numeric value [1..99] (order=${order})")
  }

  $repo = $name

  concat::fragment{ "${pacman_config}_repo_${repo}":
    target  => $pacman_config,
    content => template('pacman/pacman.conf.repo.erb'),
    order   => $order,
  }
}
