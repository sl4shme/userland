class userland::packer {

    $basedevel=["autoconf","automake","binutils","bison","fakeroot","file","findutils","flex","gawk","gcc","gettext","grep","groff","gzip","libtool","m4","make","pacman","patch","pkg-config","sed","sudo","texinfo","util-linux","which","fakeroot","jshon","expac","git","curl"]

    group { 'aur' :
        ensure => present,
    }

    if $userland::installer::http_proxy != '' { 
        exec { 'pacman-refresh-packer':
            command     => "/usr/bin/pacman-db-upgrade ; /sbin/pacman -Sy",
            environment => ["http_proxy=$userland::installer::httpProxy","https_proxy=$userland::installer::httpsProxy"],
            creates     => '/usr/bin/packer',
            before      => [File['/usr/bin/packer'],Package[$basedevel]],
        }
    } else {
        exec { 'pacman-refresh-packer':
            command     => "/usr/bin/pacman-db-upgrade ; /sbin/pacman -Sy",
            creates     => '/usr/bin/packer',
            before      => [File['/usr/bin/packer'],Package[$basedevel]],
        }
    }

    ensure_packages($basedevel)

    user { 'aur' :
        ensure  => present,
        shell   => '/bin/bash',
        home    => '/tmp/',
        gid     => 'aur',
        require => Group['aur'],
    }

    file { '/usr/bin/packer':
        ensure  => file,
        source  => "puppet:///modules/userland/packer/packer",
        mode    => 755,
        owner   => 'root',
        group   => 'root',
    }

    file { '/usr/share/man/man8/packer.8':
        ensure  => file,
        source  => "puppet:///modules/userland/packer/packer.8",
        mode    => 744,
        owner   => 'root',
        group   => 'root',
    }
}
