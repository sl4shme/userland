class userland::newsbeuter_client (
    $sshUser    = 'newsbeuter',
    $sshHost    = $userland::installer::mainSshServ,
    $ncPort     = 4242,
    $browserCmd = 'firefox'
) {
    file { "/home/$userland::installer::username/.newsbeuterCS/" :
        ensure  => directory,
        recurse => 'remote',
        owner   => "$userland::installer::username",
        group   => "$userland::installer::username",
        source  => 'puppet:///modules/userland/newsbeuterCS',
    }

    file { "/home/$userland::installer::username/.newsbeuterCS/param" :
        ensure  => file,
        owner   => "$userland::installer::username",
        group   => "$userland::installer::username",
        content => template('userland/newsbeuterClientParam.erb'),
        require => File["/home/$userland::installer::username/.newsbeuterCS/"],
    }

    file { "/home/$userland::installer::username/.local/bin/newsbeuter" :
        ensure  => link,
        target  => "/home/$userland::installer::username/.newsbeuterCS/newsbeuterClient",
        owner   => "$userland::installer::username",
        group   => "$userland::installer::username",
        require => File["/home/$userland::installer::username/.newsbeuterCS/"],
    }
}
