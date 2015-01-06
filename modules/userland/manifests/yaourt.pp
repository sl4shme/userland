class userland::yaourt {
    group { 'yaourt' :
        ensure => present,
    }
    
    user { 'yaourt' :
        ensure  => present,
        shell   => '/bin/bash',
        home    => '/tmp/',
        require => Group['yaourt'],
    }

    file { '/tmp/yaourtinstaller.sh':
        ensure  => file,
        source  => "puppet:///modules/userland/yaourtinstaller.sh",
        mode    => 774,
        owner   => 'yaourt',
        group   => 'yaourt',
        require => User['yaourt'],
    }

    exec { 'install_yaourt':
        command     => "/usr/bin/su yaourt -lc 'export http_proxy=$userland::installer::httpProxy ; export https_proxy=$userland::installer::httpsProxy ; /tmp/yaourtinstaller.sh'",
        unless      => '/usr/bin/pacman -Qk yaourt',
        logoutput   => 'on_failure',
        require     => [File['/tmp/yaourtinstaller.sh'],File_line['sudo_yaourt'],File_line['proxy_ftp']],

    }
}
