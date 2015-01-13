class userland::aur {
    group { 'aur' :
        ensure => present,
    }

    ensure_packages(["base-devel","fakeroot","jshon","expac","git","curl"])

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
