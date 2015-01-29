class userland::pass (
    $passmenu    = false,
) {
    package{'pass' :
        ensure  => installed,
    }

    if $passmenu {
        file { '/usr/bin/passmenu':
            ensure => file,
            owner  => 'root',
            group  => 'root',
            mode   => 755,
            source => "puppet:///modules/userland/passmenu",
       }
    }
}
