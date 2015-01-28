class userland::pass (
    $pgpKeyId    = "",
    $repoAddress = "",
    $forRoot     = false,
    $forUser     = false,
    $passmenu    = false,
) {
    package{'pass' :
        ensure  => installed,
    }

    if $forRoot {
        exec { 'init_root_pass' :
            command => "/usr/bin/pass init $pgpKeyId",
            creates => "/root/.password-store",
            require => Package['pass'],
        }

        exec { 'init_root_git' :
            command => "/usr/bin/pass git init",
            creates => "/root/.password-store/.git",
            require => [Exec["init_root_pass"],File["/root/.gitconfig"]],
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
            require => Package['pass'],
        }

        exec { 'init_user_git' :
            command => "/usr/bin/su $userland::installer::username -c 'pass git init'",
            creates => "/home/$userland::installer::username/.password-store/.git",
            require => [Exec["init_user_pass"],File["/home/$userland::installer::username/.gitconfig"]],
        }

        exec { 'remote_user_git' :
            command => "/usr/bin/su $userland::installer::username -c 'pass git remote add origin $repoAddress'",
            unless  => "/usr/bin/cat /home/$userland::installer::username/.password-store/.git/config | grep $repoAddress",
            require => Exec['init_user_git'],
        }
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
