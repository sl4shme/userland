class userland::config_user(
    $username,
    $manageUserSshKey = false,
    $manageRootSshKey = false,
    $manageUserPgp    = false,
    $manageRootPgp    = false,
    $userSshAuthKey   = false,
    $rootSshAuthKey   = false,
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
             file {"/home/$username/.ssh/without" :
                ensure  => file,
                owner   => $username,
                group   => $username,
                mode    => 600,
                source  => "puppet:///modules/userland/enc/without",
                require => [User["$username"],File["/home/$username/.ssh"]]
            }
           file {"/home/$username/.ssh/without.pub" :
                ensure  => file,
                owner   => $username,
                group   => $username,
                mode    => 644,
                source  => "puppet:///modules/userland/enc/without.pub",
                require => [User["$username"],File["/home/$username/.ssh"]]
            }
             file {"/home/$username/.ssh/id_rsa" :
                ensure  => file,
                owner   => $username,
                group   => $username,
                mode    => 600,
                source  => "puppet:///modules/userland/enc/id_rsa",
                require => [User["$username"],File["/home/$username/.ssh"]]
            }
           file {"/home/$username/.ssh/id_rsa.pub" :
                ensure  => file,
                owner   => $username,
                group   => $username,
                mode    => 644,
                source  => "puppet:///modules/userland/enc/id_rsa.pub",
                require => [User["$username"],File["/home/$username/.ssh"]]
            }
        }

        if $manageUserPgp {
            file {"/home/$username/.gnupg" :
                ensure  => directory,
                owner   => $username,
                group   => $username,
                mode    => 700,
                require => User["$username"],
                source  => "puppet:///modules/userland/enc/.gnupg/",
                recurse => 'remote',
            }
        }

        if $userSshAuthKey {
            $keyFile = file("/etc/puppet/modules/userland/files/enc/id_rsa.pub")
            $goodKey = split($keyFile, ' ')
    
            ssh_authorized_key{ "slashme key in user" :
                ensure  => present,
                key     => $goodKey[1],
                user    => "$username",
                type    => "ssh-rsa",
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
        file {"/root/.ssh/without" :
            ensure  => file,
            owner   => "root",
            group   => "root",
            mode    => 600,
            source  => "puppet:///modules/userland/enc/without",
        }
        file {"/root/.ssh/without.pub" :
            ensure  => file,
            owner   => "root",
            group   => "root",
            mode    => 644,
            source  => "puppet:///modules/userland/enc/without.pub",
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

    if $manageRootPgp {
        file {"/root/.gnupg" :
            ensure  => directory,
            owner   => 'root',
            group   => 'root',
            mode    => 700,
            source  => "puppet:///modules/userland/enc/.gnupg/",
            recurse => 'remote',
        }
    }

    if $rootSshAuthKey {
        $keyFileRoot = file("/etc/puppet/modules/userland/files/enc/id_rsa.pub")
        $goodKeyRoot = split($keyFileRoot, ' ')
        ssh_authorized_key{ "slashme key in root" :
            ensure  => present,
            key     => $goodKeyRoot[1],
            user    => "root",
            type    => "ssh-rsa",
        }
    }
}
