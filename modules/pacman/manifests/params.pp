# Class: pacman::params
#
# This class is Inherited by main pacman class (init.pp) and provides default
# configuration and variables.
#
# Parameters:
#
# For parameter description check comments in pacman class (init.pp).
#
class pacman::params {

  case $::osfamily {
    'Archlinux': {
      # refresh (pacman -Sy)
      $always_refresh     = true
      $refresh_timeout    = '300'

      # pacman.conf
      # [options]
      $root_dir           = undef
      $db_path            = undef
      $cache_dir          = undef
      $log_file           = undef
      $gpg_dir            = undef
      $disable_keys       = false
      $architecture       = 'auto'
      $sig_level          = 'Required DatabaseOptional'
      $local_sig_level    = 'Optional'
      $remote_sig_level   = undef
      $check_space        = true
      $hold_pkg           = 'pacman glibc'
      $ignore_pkg         = undef
      $ignore_group       = undef
      $no_upgrade         = undef
      $no_extract         = undef
      $xfer_command       = undef
      $clean_method       = undef
      $use_delta          = undef#
      $use_syslog         = false
      $color              = true
      $verbose_pkg_lists  = false
      $total_download     = true
      $iLoveCandy         = false
      #mirrorlist
      #$mirrors_manage     = false
      #$mirrors_https_only = false
      #$mirrors_auto_rank  = false

      # repositories
      $repositories = {
        'core'  => {     order => 10, },
        'extra' => {     order => 20, },
        'community' => { order => 30, },
      }

      # aur
      $enable_aur   = false

      # mirrorlist
      $mirrorlist_manage  = false
      $mirrorlist_ipv4    = true
      $mirrorlist_ipv6    = false
      $mirrorlist_http    = true
      $mirrorlist_https   = true
      $mirrorlist_rank    = 6

      # pacman directories
      $pacman_config      = '/etc/pacman.conf'
      $pacman_config_d    = '/etc/pacman.d/'
    }
    default: {
      fail("Unsupported osfamily (${::osfamily})")
    }
  }

  validate_string($root_dir)
}
