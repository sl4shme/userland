class userland::packer {
    group { 'aur' :
        ensure => present,
    }

    if $userland::installer::http_proxy != '' { 
        exec { 'pacman-refresh-packer':
            command     => "/usr/bin/pacman-db-upgrade ; /sbin/pacman -Sy",
            environment => ["http_proxy=$userland::installer::httpProxy","https_proxy=$userland::installer::httpsProxy"],
            creates     => '/usr/bin/packer',
            before      => [File['/usr/bin/packer'],Package[["base-devel","fakeroot","jshon","expac","git","curl"]]],
        }
    } else {
        exec { 'pacman-refresh-packer':
            command     => "/usr/bin/pacman-db-upgrade ; /sbin/pacman -Sy",
            creates     => '/usr/bin/packer',
            before      => [File['/usr/bin/packer'],Package[["base-devel","fakeroot","jshon","expac","git","curl"]]],
        }
    }

    ensure_packages(["base-devel","fakeroot","jshon","expac","git","curl"])

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
