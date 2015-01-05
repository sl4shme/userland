# Class: pacman
#
# This module manages the initial configuration of pacman. It is responsible for
# managing pacman.conf on your system.
#
# Parameters:
#
# Parameter names mimic those in pacman.conf, the only difference is that we do
# not use CamelCase. For more in-depth explanation of what parameters do, please
# consult `man pacman.conf` on your Arch Linux system.
#
#   [*always_refresh*]    - always refresh repositories (pacman -Sy).
#     (true|false)          [default: true]
#   [*pacman_config*]     - set pacman configuration file
#     (string)              [default: '/etc/pacman.conf']
#   [*pacman_config_d*]   - set pacman configuration directory (with trailing /)
#     (string)              [default: '/etc/pacman.d/']
#   [*repositories*]      - lets you define repositories to enable. This lets
#     (array)               you add official and custom repositories and specify
#                           additional parameters such as SigLevel or Order.
#                           Please consult man pacman.conf and README.md.
#                           [default: core, extra, community]
#   [*enable_aur*]        - enable management of packages from AUR via
#     (true|false)          `pacman::aur` definition. This installs `yaourt`
#                           by including 'pacman::yaourt' class.
#                           [default: false]
#   [*mirrorlist_manage*] - enable management of mirrorlist. Will overwrite
#     (true|false)          mirrorlist:  https://www.archlinux.org/mirrorlist/
#                           [default: false]
#   [*mirrorlist_ipv4*]   - use IPv4 mirrors
#     (true|false)          [default: true]
#   [*mirrorlist_ipv6*]   - use IPv6 mirrors
#     (true|false)          [default: false]
#   [*mirrorlist_http*]   - download http mirrors
#     (true|false)          [default: true]
#   [*mirrorlist_https*]  - download https mirrors
#     (true|false)          [default: true]
#   [*mirrorlist_rank*]   - when specified, ranks number of mirrors by speed
#     (number|undef)        using rankmirror package
#                           [default: undef]
#   [*mirrorlist_force*]  - when set to true will force mirrorlist update.
#     (true|false)          Only set this to true temporarily while debugging.
#                           [default: false]
#   [*root_dir*]          - overrides location when pacman installs packages
#     (string|undef)        [default: undef]
#   [*db_path*]           - overrides location of database
#     (string|undef)        [default: undef]
#   [*cache_dir*]         - overrides location of package cache.
#     (string|undef)        [default: undef]
#   [*log_file*]          - overrides location for pacman.log file
#     (string|undef)        [default: undef]
#   [*gpg_dir*]           - overrides default location for GnuPG configuration
#     (string|undef)        files used by pacman.
#                           [default: undef]
#   [*disable_keys*]      - disables requirement for all packages to be signed.
#     (true|false)          [default: false]
#   [*architecture*]      - If set, only allow installation of package of the
#                           given architecture. Defaults to auto if undefined.
#     (auto|i686|x86_64)    [default: auto]
#   [*sig_level*]         - set default signature verification level (default).
#     (string|undef)        Only works if disable_keys = false.
#                           [default: 'Required DatabaseOptional']
#   [*local_sig_level*]   - set default signature verification level (local).
#     (string|undef)        Only works if disable_keys = false.
#                           [default: "Optional"]
#   [*remote_sig_level*]  - set default signature verification level (remote).
#     (string|undef)        Only works if disable_keys = false.
#                           [default: undef]
#   [*check_space*]       - performs an approximate check for adequate available
#     (true|false)          disk space before installing packages.
#                           [default: true]
#   [*hold_pkg*]          - list of packages to require confirmation before
#     (string|undef)        being removed. Separate by space (e.g. 'glibc vim')
#                           [default: ['pacman glibc']]
#   [*ignore_pkg*]        - list of packages to prevent from upgrading. Separate
#     (string|undef)        by space (e.g. 'mariadb nginx').
#                           Shell-style glob patterns are allowed.
#                           [default: undef]
#   [*ignore_group*]      - list of package groups to prevent from upgrading.
#     (string|undef)        Separate by space (e.g. 'base base-devel').
#                           Shell-style glob patterns are allowed.
#                           [default: undef]
#   [*no_upgrade*]        - list of files who should never be updated. Pacman
#     (string|undef)        will create a file with .pacnew extension instead.
#                           Separated by space (e.g. 'etc/passwd etc/shadow').
#                           [default: undef]
#   [*no_extract*]        - list all files which should never be extracted from
#     (string|undef)        package into filesystem.
#                           [default: undef]
#   [*xfer_command*]      - if set, an external program will be used to download
#     (string|undef)        all remote files (see man pacman.conf).
#                           [default: undef]
#   [*color*]             - if set, enables colors when pacman is on a tty.
#     (true|false)          [default: true]
#   [*verbose_pkg_lists*] - displays name, version and size of target packages.
#     (true|false)          [default: false]
#   [*total_download*]    - Display download stats of total download, not
#     (true|false)          current pacakge.
#                           [default: true]
#
# Actions:
#
# Requires:
#   puppetlabs/stdlib
#   puppetlabs/concat
#
# Sample Usage:
#
#  Manage puppet.conf (generates Arch Linux default pacman.conf, with core,
#  extra and community repos enabled, managed and ranked mirrorlist and AUR)
#
#       class { 'pacman':
#         enable_aur        => true,
#         mirrorlist_manage => true,
#         mirrorlist_rank   => 4,
#       }
#
#  See README.md and tests directory for more examples and information
#
class pacman(
  $always_refresh     = $pacman::params::always_refresh,
  $pacman_config      = $pacman::params::pacman_config,
  $pacman_config_d    = $pacman::params::pacman_config_d,
  $repositories       = $pacman::params::repositories,
  $enable_aur         = $pacman::params::enable_aur,
  $mirrorlist_manage  = $pacman::params::mirrorlist_manage,
  $mirrorlist_ipv4    = $pacman::params::mirrorlist_ipv4,
  $mirrorlist_ipv6    = $pacman::params::mirrorlist_ipv6,
  $mirrorlist_http    = $pacman::params::mirrorlist_http,
  $mirrorlist_https   = $pacman::params::mirrorlist_https,
  $mirrorlist_rank    = $pacman::params::mirrorlist_rank,
  $mirrorlist_force   = $pacman::params::mirrorlist_force,
  $root_dir           = $pacman::params::root_dir,
  $db_path            = $pacman::params::db_path,
  $cache_dir          = $pacman::params::cache_dir,
  $log_file           = $pacman::params::log_file,
  $gpg_dir            = $pacman::params::gpg_dir,
  $disable_keys       = $pacman::params::disable_keys,
  $architecture       = $pacman::params::architecture,
  $sig_level          = $pacman::params::sig_level,
  $local_sig_level    = $pacman::params::local_sig_level,
  $remote_sig_level   = $pacman::params::remote_sig_level,
  $check_space        = $pacman::params::check_space,
  $hold_pkg           = $pacman::params::hold_pkg,
  $ignore_pkg         = $pacman::params::ignore_pkg,
  $ignore_group       = $pacman::params::ignore_group,
  $no_upgrade         = $pacman::params::no_upgrade,
  $no_extract         = $pacman::params::no_extract,
  $xfer_command       = $pacman::params::xfer_command,
  $clean_method       = $pacman::params::clean_method,
  $use_delta          = $pacman::params::use_delta,
  $use_syslog         = $pacman::params::use_syslog,
  $color              = $pacman::params::color,
  $verbose_pkg_lists  = $pacman::params::verbose_pkg_lists,
  $total_download     = $pacman::params::total_download,
  $iLoveCandy         = $pacman::params::iLoveCandy,
) inherits pacman::params {

  # validate parameter types
  validate_bool($always_refresh, $enable_aur, $disable_keys, $check_space,
    $use_syslog, $color, $verbose_pkg_lists, $total_download,
    $mirrorlist_manage, $mirrorlist_ipv6, $mirrorlist_https)
  validate_hash($repositories)
  validate_string($pacman_config, $pacman_config_d)

  if $mirrorlist_rank != false {
    if !is_numeric($mirrorlist_rank) {
      fail("mirrorlist_rank parameter must be either false or numeric")
    }
  } else {
    validate_bool($mirrorlist_rank)
  }

  if $root_dir != undef {
    validate_string($root_dir)
  }

  if $db_path != undef {
    validate_string($db_path)
  }

  if $cache_dir != undef {
    validate_string($cache_dir)
  }

  if $log_file != undef {
    validate_string($log_file)
  }

  if $gpg_dir != undef {
    validate_string($gpg_dir)
  }

  if $architecture != undef {
    validate_string($architecture)
  }

  if $sig_level != undef {
    validate_string($sig_level)
  }

  if $local_sig_level != undef {
    validate_string($local_sig_level)
  }

  if $remote_sig_level != undef {
    validate_string($remote_sig_level)
  }

  if $hold_pkg != undef {
    validate_string($hold_pkg)
  }

  if $ignore_pkg != undef {
    validate_string($ignore_pkg)
  }

  if $ignore_group != undef {
    validate_string($ignore_group)
  }

  if $no_upgrade != undef {
    validate_string($no_upgrade)
  }

  if $no_extract != undef {
    validate_string($no_extract)
  }

  if $clean_method != undef {
    validate_string($clean_method)
  }

  if $use_delta != undef {
    valiate_string($use_delta)
  }

  if $xfer_command != undef {
    validate_string($xfer_command)
  }

  # refresh
  exec { 'pacman-refresh':
    command     => "/sbin/pacman -Sy",
    logoutput   => 'on_failure',
    refreshonly => true,
    timeout     => $refresh_timeout,
  }

  if $always_refresh == true {
    Exec <| title=='pacman-refresh' |> {
      refreshonly => false,
    }
  }

  concat { $pacman_config:
    owner          => 'root',
    group          => 'root',
    mode           => '0644',
    warn           => true,
    ensure_newline => true,
    order          => 'numeric',
    replace        => true,
  }

  concat::fragment{ "${pacman_config}_header":
    target  => $pacman_config,
    content => template('pacman/pacman.conf.erb'),
    order   => '01',
    ensure  => 'present',
  }

  create_resources('pacman::repo', $repositories)

  # AUR
  if $enable_aur == true {
    class { 'pacman::yaourt': }
  }

  # mirrorlist
  if $mirrorlist_manage == true {
    class { 'pacman::mirrorlist':
      ipv4  => $mirrorlist_ipv4,
      ipv6  => $mirrorlist_ipv6,
      http  => $mirrorlist_http,
      https => $mirrorlist_https,
      rank  => $mirrorlist_rank,
      force => $mirrorlist_force,
    }
  }

  # Need anchor to provide containment for dependencies.
  anchor { 'pacman::refresh':
    require => Exec['pacman-refresh'],
  }

}
