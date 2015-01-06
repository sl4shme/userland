class userland::package_manager(
    $installYaourt   = false,
    $iLoveCandy      = false,
    $enableCore      = true,
    $enableExtra     = true,
    $enableCommunity = true,
    $enableMultilib  = false,
) {
    file{ '/etc/pacman.conf' :
        ensure  => file,
        content => template("userland/pacman.conf.erb"),
        mode    => 644,
        owner   => "root",
        group   => "root",
    }

    file{ '/etc/pacman.d/otherRepo' :
        ensure => file,
    }

    if $installYaourt{
       class {"userland::yaourt" : }
    }
}

