class userland::tunnel_server {
    group { 'tunnel':
        ensure => present,
    }

    user { 'tunnel' :
        ensure     => present,
        gid        => 'tunnel',
        managehome => true,
        require    => Group['tunnel'],
    }

    $keyFile = file("/etc/puppet/modules/userland/files/enc/without.pub")
    $goodKey = split($keyFile, ' ')
    ssh_authorized_key{ "slashme key in tunnel" :
        ensure  => present,
        key     => $goodKey[1],
        user    => 'tunnel',
        type    => "ssh-rsa",
        require => User['tunnel'],
    }
}
