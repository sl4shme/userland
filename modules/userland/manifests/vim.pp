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
            ensure  => file,
            source  => "puppet:///modules/userland/.vimrc",
            owner   => "$userland::installer::username",
            group   => "$userland::installer::username",
        }

        file { "/home/$userland::installer::username/.vim/.vimrcInsVundle" :
            ensure  => file,
            source  => "puppet:///modules/userland/.vimrcInsVundle",
            owner   => "$userland::installer::username",
            group   => "$userland::installer::username",
            before  => Exec['userVimInstall'],
            require => File["/home/$userland::installer::username/.vim"],
        }

        exec {'userVimInstall' :
            command     => "/usr/bin/su  $userland::installer::username -lc 'export http_proxy=$userland::installer::httpProxy ; export https_proxy=$userland::installer::httpsProxy ; vim -u /home/$userland::installer::username/.vim/.vimrcInsVundle +PluginInstall +qall'",
            require     => File["/home/$userland::installer::username/.vim"],
            onlyif      => "/usr/bin/ls /home/$userland::installer::username/.vim/bundle | wc -l | grep 1",
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

        file { "/root/.vim/.vimrcInsVundle" :
            ensure  => file,
            source  => "puppet:///modules/userland/.vimrcInsVundle",
            owner   => "root",
            group   => "root",
            before  => Exec['rootVimInstall'],
            require => File["/root/.vim"],
        }

        exec {'rootVimInstall' :
            command     => "/usr/bin/vim -u /root/.vim/.vimrcInsVundle +PluginInstall +qall",
            require     => File["/root/.vim"],
            onlyif      => "/usr/bin/ls /root/.vim/bundle | wc -l | grep 1",
            environment => ["http_proxy=$userland::installer::httpProxy","http_proxy=$userland::installer::httpProxy"],
        }
    }
}

