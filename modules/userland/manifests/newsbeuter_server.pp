class userland::newsbeuter_server (
    $ncPort   = 4242,
) {
    group { 'newsbeuter':
        ensure => present,
    }

    user { 'newsbeuter' :
        ensure     => present,
        gid        => 'newsbeuter',
        managehome => true,
        require    => Group['newsbeuter'],
    }

    $keyFile = file("/etc/puppet/modules/userland/files/enc/id_rsa.pub")
    $goodKey = split($keyFile, ' ')
    ssh_authorized_key{ "slashme key in newsbeuter" :
        ensure  => present,
        key     => $goodKey[1],
        user    => 'newsbeuter',
        type    => "ssh-rsa",
        require => User['newsbeuter'],
    }

    $list = ["newsbeuter","tmux","openbsd-netcat"]
    ensure_packages($list)

    file { '/home/newsbeuter/.newsbeuter/' :
        ensure  => directory,
        owner   => 'newsbeuter',
        group   => 'newsbeuter',
        require => User['newsbeuter'],
    }

    file { '/home/newsbeuter/.newsbeuter/urls' :
        ensure  => file,
        owner   => 'newsbeuter',
        group   => 'newsbeuter',
        source  => 'puppet:///modules/userland/urls',
        require => File['/home/newsbeuter/.newsbeuter/'],
    }

    file { '/home/newsbeuter/.newsbeuter/config' :
        ensure  => file,
        owner   => 'newsbeuter',
        group   => 'newsbeuter',
        source  => 'puppet:///modules/userland/newsbeuterConfig',
        require => File['/home/newsbeuter/.newsbeuter/'],
    }

    file { '/home/newsbeuter/.newsbeuter/config' :
        ensure  => file,
        owner   => 'newsbeuter',
        group   => 'newsbeuter',
        source  => 'puppet:///modules/userland/newsbeuterConfig',
        require => File['/home/newsbeuter/.newsbeuter/'],
    }

    file { '/home/newsbeuter/newsbeuterCS/' :
        ensure  => directory,
        recurse => 'remote',
        owner   => 'newsbeuter',
        group   => 'newsbeuter',
        source  => 'puppet:///modules/userland/newsbeuterCS',
        require => User['newsbeuter'],
    }

    file { '/home/newsbeuter/newsbeuterCS/param' :
        ensure  => file,
        owner   => 'newsbeuter',
        group   => 'newsbeuter',
        content => template('userland/newsbeuterServerParam.erb'),
        require => File['/home/newsbeuter/newsbeuterCS/'],
    }
}
