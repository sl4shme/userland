# Class: pacman::mirrorlist
#
# This class manages mirrorlist on your system. It will redownload mirrorlist
# every 30 days from from https://www.archlinux.org/mirrorlist/ with specified
# mirrors according to parameters (ipv4/ipv6 and http/https).
# For this it will install and use /usr/local/mirrorlist_check.sh script.
# It can optionally use rankmirrors script to rank mirrors by speed.
#
# This class should be managed via main pacman class and should
# not be included separately.
#
# If you decide to use this class separately, make sure you set
# $mirrorlist_manage parameter in pacman class to false (or skip pacman class)
#
# Dependencies:
#   curl package (pacman already depends on it)
#
# Parameters:
#
# Usage:
#
#   Should not be included manually as the inclusion is controlled by
#   $mirrorlist_manage parameter in pacman class. If you, however, decide to
#   use this separately, you can follow examples below.
#
#   HTTPS only IPv4 mirrors (rank 4 fastest):
#
#       class { 'pacman::mirrorlist':
#         http  => false,
#         https => true,
#         rank  => 4,
#       }
#
#   If you update the configuration you can force mirrorlist update by setting
#   force parameters to true:
#
#      class { 'pacman::mirrorlist':
#         http  => false,
#         https => true,
#         rank  => 4,
#         force => true,
#       }
#
class pacman::mirrorlist(
  $ipv4            = $pacman::params::mirrorlist_ipv4,
  $ipv6            = $pacman::params::mirrorlist_ipv6,
  $http            = $pacman::params::mirrorlist_http,
  $https           = $pacman::params::mirrorlist_https,
  $rank            = $pacman::params::mirrorlist_rank,
  $force           = $pacman::params::mirrorlist_force,
  $pacman_config   = $pacman::params::pacman_config,
  $pacman_config_d = $pacman::params::pacman_config_d,
) inherits pacman::params {
  # validation
  validate_bool($ipv4, $ipv6, $http, $https, $force)
  if $rank != false {
    if !is_numeric($rank) {
      fail("rank parameter for pacman::mirrorlist must be either 'false' or
      numeric")
    }
  } else {
    validate_bool($rank)
  }
  if $ipv4 == false and $ipv6 == false {
    fail("you must enable either ipv4 or ipv6 (or both) for pacman:mirrorlist to
    work")
  }

  if $http == false and $https == false {
    fail("you must enable either http or https (or both) for pacman:mirrorlist
    to work")
  }

  # mirrorlist fetch setup
  # protocols (ipv4/ipv6)
  if $ipv4 == true {
    $ip4 = '&ip_version=4'
  } else {
    $ip4 = ''
  }
  if $ipv6 == true {
    $ip6 = '&ip_version=6'
  } else {
    $ip6 = ''
  }

  # protocols (http/https)
  if $http == true {
    $proth = '&protocol=http'
  } else {
    $proth = ''
  }
  if $https == true {
    $prots = '&protocol=https'
  } else {
    $prots = ''
  }

  # remove mirrorlist-fetched if force update is needed
  if $force == true {
    exec { "/bin/rm ${pacman_config_d}mirrorlist-fetched":
      before => File['mirrorlist-check'],
    }
  }

  # make sure we setup mirrorlist_check.sh script in system
  file { 'mirrorlist-check':
    path    => '/usr/local/bin/mirrorlist_check.sh',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    ensure  => 'present',
    content => template('pacman/mirrorlist_check.sh.erb')
  } ~>
  # use curl to fetch new mirrorlist with mirrorlist-fetch parameters
  exec { 'mirrorlist-fetch':
    command   => "/bin/curl -o ${pacman_config_d}mirrorlist-fetched 'https://www.archlinux.org/mirrorlist/?country=all${ip4}${ip6}${proth}${prots}'",
    unless    => '/usr/local/bin/mirrorlist_check.sh',
    logoutput => 'on_failure',
  } ~>
  # copy mirrorlist-fetched to mirrorlist-all and use sed to uncomment servers
  exec { 'mirrorlist-sed':
    command     => "/bin/cp ${pacman_config_d}mirrorlist-fetched ${pacman_config_d}mirrorlist-all && /bin/sed -i 's/^#Server/Server/' ${pacman_config_d}mirrorlist-all",
    logoutput   => 'on_failure',
    refreshonly => true,
  }
  # if rank is set, rank servers in mirrorlist-all to mirrorlist (rankmirrors)
  if $rank != false {
    exec { 'mirrorlist-rank':
      command     => "/bin/rankmirrors -n ${rank} ${pacman_config_d}mirrorlist-all > ${pacman_config_d}mirrorlist",
      subscribe   => Exec['mirrorlist-fetch'],
      require     => Exec['mirrorlist-sed'],
      logoutput   => 'on_failure',
      refreshonly => true,
    }
  } else {
    # if rank is disabled, then just copy mirrorlist-all file as mirrorlist
    exec { 'mirrorlist-rank':
      command   => "/bin/cp ${pacman_config_d}mirrorlist-all ${pacman_config_d}mirrorlist",
      subscribe   => Exec['mirrorlist-fetch'],
      require     => Exec['mirrorlist-sed'],
      logoutput   => 'on_failure',
      refreshonly => true,
    }
  }

}
