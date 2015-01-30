class userland::smuxi_server (
) {
    group { 'smuxi':
        ensure => present,
    }

    user { 'smuxi' :
        ensure     => present,
        gid        => 'smuxi',
        managehome => true,
        require    => Group['smuxi'],
    }

    $keyFile = file("/etc/puppet/modules/userland/files/enc/id_rsa.pub")
    $goodKey = split($keyFile, ' ')
    ssh_authorized_key{ "slashme key in smuxi" :
        ensure  => present,
        key     => $goodKey[1],
        user    => 'smuxi',
        type    => "ssh-rsa",
        require => User['smuxi'],
    }

    $list = ["smuxi-server"]
    ensure_packages($list)

    file { '/home/smuxi/.config/' :
        ensure  => directory,
        owner   => 'smuxi',
        group   => 'smuxi',
        require => User['smuxi'],
    }

    file { '/home/smuxi/.config/smuxi/' :
        ensure  => directory,
        owner   => 'smuxi',
        group   => 'smuxi',
        require => File['home/smuxi/.config/'],
    }

    file { '/home/smuxi/.config/smuxi/smuxi-engine.ini' :
        ensure  => file,
        owner   => 'smuxi',
        group   => 'smuxi',
        source  => 'puppet:///modules/userland/enc/smuxi-engine.ini',
        require => File['/home/smuxi/.config/smuxi/'],
    }

    file { '/usr/lib/systemd/system/smuxi-server.service' :
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => 744,
        source  => "puppet:///modules/userland/smuxi-server.service",
        require => File['/home/smuxi/.config/smuxi/smuxi-engine.ini'],
    }

    service { "smuxi-server" :
        ensure  => running,
        enable => true,
        require => File['/usr/lib/systemd/system/smuxi-server.service'],
    }
}
