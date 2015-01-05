class userland::vim(
    $forUser = false,
    $forRoot = false,
) {
    package {"vim":
        ensure => installed,
    }

    if $forUser {
        file { "/home/$userland::installer::username/.vim" :
            ensure  => directory,
            recurse => remote,
            source  => "puppet:///modules/userland/.vim",
            owner   => "$userland::installer::username",
            group   => "$userland::installer::username",
        }

        file { "/home/$userland::installer::username/.vimrc" :
            ensure => file,
            source => "puppet:///modules/userland/.vimrc",
            owner   => "$userland::installer::username",
            group   => "$userland::installer::username",
        }
    }

    if $forRoot {
        file { "/root/.vim" :
            ensure  => directory,
            recurse => remote,
            source  => "puppet:///modules/userland/.vim",
            owner   => "root",
            group   => "root",
        }

        file { "/root/.vimrc" :
            ensure => file,
            source => "puppet:///modules/userland/.vimrc",
            owner   => "root",
            group   => "root",
        }
    }
}

