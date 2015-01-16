class userland::git (
    $username,
    $email,
    $forRoot = false,
    $forUser = false,
) {
    if $forRoot {
        file { "/root/.gitconfig" :
            ensure  => file,
            content => template('userland/.gitconfig'),
            owner   => "root",
            group   => "root",
        }
    }

    if $forUser {
        file { "/home/$userland::installer::username/.gitconfig" :
            ensure  => file,
            content => template('userland/.gitconfig'),
            owner   => "$userland::installer::username",
            group   => "$userland::installer::username",
        }
    }
}
