class userland::yaourt {
    file { '/tmp/yaourtinstaller.sh':
        ensure  => file,
        source  => "puppet:///modules/userland/yaourtinstaller.sh",
        mode    => 774,
        owner   => 'root',
        group   => 'root',
    }

    exec { 'install_yaourt':
        command     => "/usr/bin/export http_proxy=$userland::installer::httpProxy ; export https_proxy=$userland::installer::httpsProxy ; /tmp/yaourtinstaller.sh",
        unless      => '/usr/bin/pacman -Qk yaourt',
        require     => File['/tmp/yaourtinstaller.sh'],
        logoutput   => 'on_failure',
    }
}
