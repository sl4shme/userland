class userland::git (
    $username,
    $email,
    $forRoot = false,
    $forUser = false,
) {
    if $forRoot {
        git::config { 'user.name':
            value => $username,
        }

        git::config { 'user.email':
            value => $email,
        }
    }

    if $forUser {
        git::config { 'userUsername':
            section => 'user',
            key     => 'name',
            value   => $username,
            user    => $userland::installer::username,
        }

        git::config { 'userEmail':
            section => 'user',
            key     => 'email',
            value   => $email,
            user    => $userland::installer::username,
        }
    }
}
