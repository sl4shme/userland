pacman
======

[![Build
Status](https://travis-ci.org/edvinasme/puppet-pacman.png?branch=master)](https://travis-ci.org/edvinasme/puppet-pacman)

## Description

Puppet module lets you manage pacman configuration, repositories and mirrorlist.
Provides ability to install packages from AUR (via yaourt).

Supports Arch Linux but should be extendable to any Arch Linux based
distributions using pacman. Patches are welcome.

=======

Overview
--------

The Pacman module provides a simple interface for managing pacman.conf,
repositories and mirrorlist. This module will overwrite your pacman.conf so you
should at least configure repositories as it will only enable `core`, `extra`
and `community` repositories if none are specified.
It can also be used to manage `mirrorlist`. It will use
https://www.archlinux.org/mirrorlist/ to fetch required mirrors every 30 days
and can optionally sort them by speed using rankmirrors.
This is all configurable.

This module depends on `puppetlabs/stdlib, >=3.0.0` and 
`puppetlabs/concat, >=1.0.0` modules.

Setup
-----

**What Pacman affects:**

* /etc/pacman.conf, /etc/pacman.d/gpg and optionally /etc/pacman.d/mirrorlist
* pacman configuration
* pacman repositories
* mirrorlist (when `mirrorlist_manage` parameter is enabled)
* mirrorlist rank (when `mirrorlist_rank` parameter is set to a numeric value)
* Installs `yaourt` package and `base-devel` package group (when AUR is enabled)
* Manages packages from AUR on your system (via `yaourt`, when AUR is enabled)

### Examples

If you skip `repositories` parameter, pacman module will define `core`, `extra`
and `community` repositories by default.

#### Repositories

To begin using the Pacman module with specific repositories, declare the class:

    $repositories = {
      'core'      => { order => '10', },
      'extra'     => { order => '20', },
      'community' => { order => '30', },
      'multilib'  => { order => '40', },
    }

    class { 'pacman':
      repositories => $repositories,
    }

    # You can also add additional repositories:
    pacman::repo { 'repo-ck':
      server => 'http://repo-ck.com/$arch',
      order  => '50',
    }

If you skip `repositories` parameter, pacman module will define `core`, `extra`
and `community` repositories by default. The examples above will skip definition
of repositories and let pacman define default ones instead.

#### Mirrorlist

Pacman module can manage your mirrorlist. You can enable it via
`mirrorlist_manage` parameter:

    class { 'pacman':
      mirrorlist_manage => true,
    }

This will enable all IPv4 http and https based mirrors. It will install
`/usr/local/bin/mirrorlist_check.sh` script on your system which it will use to
check if mirrorlist is 30 days old to redownload it.

If you want to specify mirrors you want to use, you can pass additional
parameters. This will fetch IPv4 https-only mirrors:

    class { 'pacman':
      mirrorlist_manage => true,
      mirrorlist_ipv4   => true,
      mirrorlist_ipv6   => false,
      mirrorlist_http   => false,
      mirrorlist_https  => true,
    }

#### Ranked Mirrorlist

Pacman module can use `rankmirrors` to rank specified amount of mirrors from
downloaded mirrorlist. This is controlled by `mirrorlist_rank` parameter which
can be either set to `false` or numeric value of mirrors to rank.

This will fetch IPv4 https-only mirrors and only use 4 ranked by speed:

    class { 'pacman':
      mirrorlist_manage => true,
      mirrorlist_ipv4   => true,
      mirrorlist_ipv6   => false,
      mirrorlist_http   => false,
      mirrorlist_https  => true,
      mirrorlist_rank   => true,
    }

#### AUR

Puppet module support installing packages from AUR. This is accomplished by
installing `yaourt` on your system. To enable AUR functionality you need to set
`enable_aur` parameter to true. Then you can use `pacman::aur` definitions to
install various packages from AUR:

    class { 'pacman':
      enable_aur => true,
    }

    # Install Package
    pacman::aur { 'cowsay-futurama': }

    # Uninstall Package
    pacman::aur { 'cowsay-futurama':
      ensure => 'absent',
    }


Usage
-----

Using the Pacman module consists in declaring classes that provide desired
functionality and features.

### pacman

`pacman` provides ability to manage `pacman.conf`. It supports all of pacman's
configurable parameters. You MUST always include this class in your manifests.
When in doubt on what configuration parameters do, consult `man pacman.conf`.

Most of the parameters for `pacman` are not required in general as defaults
mimic default configuration of pacman on Arch Linux system. You are STRONGLY
advised to configure repositories, as by default only `core`, `extra` and
`community` repositories will be enabled. To override default repositories, you
can specify them when initializing `pacman` class:

    $repos = {
      'core'  => { order => '10' },
      'extra' => { order => '20' },
      'community' => { order => '30' },
      'multilib' => { order => '40' },
      'archlinuxfr' => { server => 'http://repo.archlinux.fr/$arch', order => '50' },
    },

    class { 'pacman':
      repositories         => $repos,
    }

Puppet will manage your system's `pacman.conf` file.

#### Parameters

*   [*always_refresh*]    - always refresh repositories (pacman -Sy).
     (true|false)          [default: true]
*   [*pacman_config*]     - set pacman configuration file
     (string)              [default: '/etc/pacman.conf']
*   [*pacman_config_d*]   - set pacman configuration directory (with trailing /)
     (string)              [default: '/etc/pacman.d/']
*   [*repositories*]      - lets you define repositories to enable. This lets
     (array)               you add official and custom repositories and specify
                           additional parameters such as SigLevel or Order.
                           Please consult man pacman.conf and README.md.
                           [default: core, extra, community]
*   [*enable_aur*]        - enable management of packages from AUR via
     (true|false)          `pacman::aur` definition. This installs `yaourt`
                           by including 'pacman::yaourt' class.
                           [default: false]
*   [*mirrorlist_manage*] - enable management of mirrorlist. Will overwrite
     (true|false)          mirrorlist:  https://www.archlinux.org/mirrorlist/
                           [default: false]
*   [*mirrorlist_ipv4*]   - use IPv4 mirrors
     (true|false)          [default: true]
*   [*mirrorlist_ipv6*]   - use IPv6 mirrors
     (true|false)          [default: false]
*   [*mirrorlist_http*]   - download http mirrors
     (true|false)          [default: true]
*   [*mirrorlist_https*]  - download https mirrors
     (true|false)          [default: true]
*   [*mirrorlist_rank*]   - when specified, ranks number of mirrors by speed
     (number|undef)        using rankmirror package
                           [default: undef]
*   [*mirrorlist_force*]  - when set to true will force mirrorlist update.
     (true|false)          Only set this to true temporarily while debugging.
                           [default: false]
*   [*root_dir*]          - overrides location when pacman installs packages
     (string|undef)        [default: undef]
*   [*db_path*]           - overrides location of database
     (string|undef)        [default: undef]
*   [*cache_dir*]         - overrides location of package cache.
     (string|undef)        [default: undef]
*   [*log_file*]          - overrides location for pacman.log file
     (string|undef)        [default: undef]
*   [*gpg_dir*]           - overrides default location for GnuPG configuration
     (string|undef)        files used by pacman.
                           [default: undef]
*   [*disable_keys*]      - disables requirement for all packages to be signed.
     (true|false)          [default: false]
*   [*architecture*]      - If set, only allow installation of package of the
                           given architecture. Defaults to auto if undefined.
     (auto|i686|x86_64)    [default: auto]
*   [*sig_level*]         - set default signature verification level (default).
     (string|undef)        Only works if disable_keys = false.
                           [default: 'Required DatabaseOptional']
*   [*local_sig_level*]   - set default signature verification level (local).
     (string|undef)        Only works if disable_keys = false.
                           [default: "Optional"]
*   [*remote_sig_level*]  - set default signature verification level (remote).
     (string|undef)        Only works if disable_keys = false.
                           [default: undef]
*   [*check_space*]       - performs an approximate check for adequate available
     (true|false)          disk space before installing packages.
                           [default: true]
*   [*hold_pkg*]          - list of packages to require confirmation before
     (string|undef)        being removed. Separate by space (e.g. 'glibc vim')
                           [default: ['pacman glibc']]
*   [*ignore_pkg*]        - list of packages to prevent from upgrading. Separate
     (string|undef)        by space (e.g. 'mariadb nginx').
                           Shell-style glob patterns are allowed.
                           [default: undef]
*   [*ignore_group*]      - list of package groups to prevent from upgrading.
     (string|undef)        Separate by space (e.g. 'base base-devel').
                           Shell-style glob patterns are allowed.
                           [default: undef]
*   [*no_upgrade*]        - list of files who should never be updated. Pacman
     (string|undef)        will create a file with .pacnew extension instead.
                           Separated by space (e.g. 'etc/passwd etc/shadow').
                           [default: undef]
*   [*no_extract*]        - list all files which should never be extracted from
     (string|undef)        package into filesystem.
                           [default: undef]
*   [*xfer_command*]      - if set, an external program will be used to download
     (string|undef)        all remote files (see man pacman.conf).
                           [default: undef]
*   [*color*]             - if set, enables colors when pacman is on a tty.
     (true|false)          [default: true]
*   [*verbose_pkg_lists*] - displays name, version and size of target packages.
     (true|false)          [default: false]
*   [*total_download*]    - Display download stats of total download, not
     (true|false)          current pacakge.
                           [default: true]

### pacman::repo

If you want to add additional repositories after `pacman` class has been
initialized, you can use `pacman::repo` definition. It is important to define
order correctly, as pacman uses it when deciding from which repository to
install a package based on order. Please use integeres between 10 and 99.
DO NOT use strings!

    class { 'pacman': }

    pacman::repo { 'archlinuxfr':
        server      => 'http://repo.archlinux.fr/$arch',
        order       => 80,
    }

    pacman::repo { 'repo-ck':
        server      => 'http://repo-ck.com/$arch',
        order       => 90,
    }

#### Parameters

*   [*server*]      - specify server url (e.g. "http://repo.archlinux.fr/$arch")
     (string|undef)  You can skip this if you want to enable official
                     repository and use mirrorlist.
                     [default: "mirrorlist"]
*   [*sig_level*]   - specify signature verification level for repository
     (string|undef)  [default: undef]
*   [*order*]       - specify order for repository (see man pacman.conf for more
     (numeric)       information). Number must be in range of [1..99].
                     [default: 99]

### pacman::aur

Lets you install packages from AUR. This will only work if you have
`$enable_aur` parameter set to `true` in while including `pacman` class.
`pacman` class will include `pacman::yaourt` which automatically installs
`base-devel` package group (required to build packages from AUR) and will
install `package-query` and `yaourt` packages via https://aur.sh webservice.
Otherwise you have to include `pacman::yaourt` class manually.

    class { 'pacman':
      enable_aur => true,
    }
You can then install specific packages from AUR:

    pacman::aur { 'gitlab': }

If you later decide you need to remove the package:

    pacman::aur { 'gitlab':
        ensure => 'absent'
    }

#### Parameters

*   [*ensure*]          - specify if package should be present or absent
     (present|absent)    [default: 'present']


License
-------

The code is licensed under MIT License. See LICENSE file for information.
