class userland::aur {
    group { 'aur' :
        ensure => present,
    }
    
    exec { 'pacman-refresh-packer':
        command     => "/usr/bin/pacman-db-upgrade ; /sbin/pacman -Sy",
        environment => ["http_proxy=$userland::installer::httpProxy","https_proxy=$userland::installer::httpsProxy"],
        creates     => '/usr/bin/packer',
        before      => File['/usr/bin/packer'],
    }

    package { ["base-devel","fakeroot","jshon","expac","git","curl"] :
        ensure  => installed,
        require => Exec['pacman-refresh-packer'],
    }

    user { 'aur' :
        ensure  => present,
        shell   => '/bin/bash',
        home    => '/tmp/',
        group   => 'aur',
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
