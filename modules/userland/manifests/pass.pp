class userland::pass (
    $pgpKeyId    = "",
    $repoAddress = "",
    $forRoot     = false,
    $forUser     = false,
) {
    package{'pass' :
        ensure  => installed,
    }

    if $forRoot {
        exec { 'init_root_pass' :
            command => "/usr/bin/pass init $pgpKeyId",
            creates => "/root/.password-store",
            require => [File["/root/.gnupg"],Package['pass']],
        }

        exec { 'init_root_git' :
            command => "/usr/bin/pass git init",
            creates => "/root/.password-store/.git",
            require => Exec["init_root_pass"],
        }

        exec { 'remote_root_git' :
            command => "/usr/bin/pass git remote add origin $repoAddress",
            unless  => "/usr/bin/cat /root/.password-store/.git/config | grep $repoAddress",
            require => Exec['init_root_git'],
        }
    }

    if $forUser {
        exec { 'init_user_pass' :
            command => "/usr/bin/su $userland::installer::username -c 'pass init $pgpKeyId'",
            creates => "/home/$userland::installer::username/.password-store",
            require => [File["/home/$userland::installer::username/.gnupg"],Package['pass']],
        }

        exec { 'init_user_git' :
            command => "/usr/bin/su $userland::installer::username -c 'pass git init'",
            creates => "/home/$userland::installer::username/.password-store/.git",
            require => Exec["init_user_pass"],
        }

        exec { 'remote_user_git' :
            command => "/usr/bin/su $userland::installer::username -c 'pass git remote add origin $repoAddress",
            unless  => "/usr/bin/cat /home/$userland::installer::username/.password-store/.git/config | grep $repoAddress",
            require => Exec['init_user_git'],
        }
    }
}