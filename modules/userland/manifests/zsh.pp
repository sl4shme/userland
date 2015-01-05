class userland::zsh (
    $forUser = false,
    $forRoot = false,
){
    package{["zsh","fortune-mod"] :
        ensure => installed,
    }

    if $forUser {
        file {"/home/$userland::installer::username/.zprezto" :
            ensure  => directory,
            recurse => remote,
            source  => "puppet:///modules/userland/.zprezto",
            owner   => "$userland::installer::username",
            group   => "$userland::installer::username",
        }

        file {"/home/$userland::installer::username/.zalias" :
            ensure  => file,
            source  => "puppet:///modules/userland/.zalias",
            owner   => "$userland::installer::username",
            group   => "$userland::installer::username",
        }

        file {"/home/$userland::installer::username/.zlogin" :
            ensure  => file,
            source  => "puppet:///modules/userland/.zlogin",
            owner   => "$userland::installer::username",
            group   => "$userland::installer::username",
        }

        file {"/home/$userland::installer::username/.zlogout" :
            ensure  => file,
            source  => "puppet:///modules/userland/.zlogout",
            owner   => "$userland::installer::username",
            group   => "$userland::installer::username",
        }

        file {"/home/$userland::installer::username/.zpreztorc" :
            ensure  => file,
            source  => "puppet:///modules/userland/.zpreztorc",
            owner   => "$userland::installer::username",
            group   => "$userland::installer::username",
        }

        file {"/home/$userland::installer::username/.zprofile" :
            ensure  => file,
            source  => "puppet:///modules/userland/.zprofile",
            owner   => "$userland::installer::username",
            group   => "$userland::installer::username",
        }

        file {"/home/$userland::installer::username/.zshenv" :
            ensure  => file,
            content => template('userland/zshenv.erb'),
            owner   => "$userland::installer::username",
            group   => "$userland::installer::username",
        }

        file {"/home/$userland::installer::username/.zshrc" :
            ensure  => file,
            source  => "puppet:///modules/userland/.zshrc",
            owner   => "$userland::installer::username",
            group   => "$userland::installer::username",
        }

        exec {"changeUserShell" :
            command => "/usr/bin/chsh -s /bin/zsh $userland::installer::username",
            unless  => "/usr/bin/getent passwd $userland::installer::username | cut -d: -f7 | grep zsh",
            require => Package['zsh'],
        }
    }
    if $forRoot {
        file {"/root/.zprezto" :
            ensure  => directory,
            recurse => remote,
            source  => "puppet:///modules/userland/.zprezto",
            owner   => "root",
            group   => "root",
        }

        file {"/root/.zalias" :
            ensure  => file,
            source  => "puppet:///modules/userland/.zalias",
            owner   => "root",
            group   => "root",
        }

        file {"/root/.zlogin" :
            ensure  => file,
            source  => "puppet:///modules/userland/.zlogin",
            owner   => "root",
            group   => "root",
        }

        file {"/root/.zlogout" :
            ensure  => file,
            source  => "puppet:///modules/userland/.zlogout",
            owner   => "root",
            group   => "root",
        }

        file {"/root/.zpreztorc" :
            ensure  => file,
            source  => "puppet:///modules/userland/.zpreztorc",
            owner   => "root",
            group   => "root",
        }

        file {"/root/.zprofile" :
            ensure  => file,
            source  => "puppet:///modules/userland/.zprofile",
            owner   => "root",
            group   => "root",
        }

        file {"/root/.zshenv" :
            ensure  => file,
            content => template('userland/zshenv.erb'),
            owner   => "root",
            group   => "root",
        }

        file {"/root/.zshrc" :
            ensure  => file,
            source  => "puppet:///modules/userland/.zshrc",
            owner   => "root",
            group   => "root",
        }

        exec {"changeRootShell" :
            command => "/usr/bin/chsh -s /bin/zsh root",
            unless  => '/usr/bin/getent passwd root | cut -d: -f7 | grep zsh',
            require => Package['zsh'],
        }
    }
}
