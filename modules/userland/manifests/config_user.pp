class userland::config_user(
    $username,
    $manageUserSshKey = false,
    $manageRootSshKey = false,
    $manageSudoers    = false,
) {
    if $username {
        user { "$username":
            ensure     => present,
            gid        => $username,
            groups     => ["users","audio","games","log","power","storage","video","wheel"],
            managehome => true,
        }

        group { "$username":
            ensure => present,
            system => false,
            before => User["$username"],
        }

        file { "/home/$username/.config/" :
            ensure  => directory,
            owner   => "$username",
            group   => "$username",
            require => User["$username"],
        }

        file { "/home/$username/.local/" :  
            ensure  => directory,        
            owner   => "$username",      
            group   => "$username",      
            require => User["$username"],
        }                                

        file { "/home/$username/.local/bin/" :
            ensure  => directory,
            owner   => "$username",
            group   => "$username",
            require => User["$username"],
        }

        if $manageUserSshKey {
            file {"/home/$username/.ssh" :
                ensure  => directory,
                owner   => $username,
                group   => $username,
                mode    => 700,
                require => User["$username"],
            }
             file {"/home/$username/.ssh/id_rsa" :
                ensure  => file,
                owner   => $username,
                group   => $username,
                mode    => 600,
                source  => "puppet:///modules/userland/enc/id_rsa",
                require => User["$username"],
            }
           file {"/home/$username/.ssh/id_rsa.pub" :
                ensure  => file,
                owner   => $username,
                group   => $username,
                mode    => 644,
                source  => "puppet:///modules/userland/enc/id_rsa.pub",
                require => User["$username"],
            }
        }
    }

    if $manageRootSshKey {
        file {"/root/.ssh" :
            ensure  => directory,
            owner   => "root",
            group   => "root",
            mode    => 700,
        }
        file {"/root/.ssh/id_rsa" :
            ensure  => file,
            owner   => "root",
            group   => "root",
            mode    => 600,
            source  => "puppet:///modules/userland/enc/id_rsa",
        }
        file {"/root/.ssh/id_rsa.pub" :
            ensure  => file,
            owner   => "root",
            group   => "root",
            mode    => 644,
            source  => "puppet:///modules/userland/enc/id_rsa.pub",
        }
    }
}
