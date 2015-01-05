class userland::terminator {
    file { "/home/$userland::installer::username/.config/terminator" :
        ensure => directory,
        owner  => "$userland::installer::username",
        group  => "$userland::installer::username",
    }

    package { 'terminator' :
        ensure => installed,
    }

    file { "/home/$userland::installer::username/.config/terminator/config" :
        ensure => file,
        source => 'puppet:///modules/userland/terminatorConfig',
        owner  => "$userland::installer::username",
        group  => "$userland::installer::username",

    }
}
