class userland::smuxi_client (
    $sshKey     = "/home/$userland::installer::username/.ssh/id_rsa",
    $sshUser    = $userland::installer::mainSshUser,
    $sshHost    = $userland::installer::mainSshServ,
    $sshPort    = $userland::installer::mainSshPort,
    $engineUser,
    $enginePass,
    $engineName,
) {
    ensure_packages('smuxi')

    file { "/home/$userland::installer::username/.config/smuxi" :
        ensure => directory,
        owner  => "$userland::installer::username",
        group  => "$userland::installer::username",
    }

    file { "/home/$userland::installer::username/.config/smuxi/smuxi-frontend.ini" :
        ensure  => file,
        owner   => "$userland::installer::username",
        group   => "$userland::installer::username",
        content => template('userland/smuxi-frontend.erb'),
    }
}
