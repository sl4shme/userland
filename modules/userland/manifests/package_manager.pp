class userland::package_manager(
    $installPacker   = false,
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

    if $installPacker{
       class {"userland::packer" : }
    }
}

