class userland::pacman_refresh {
    if $userland::installer::http_proxy != '' {
        exec { 'pacman_refresh' :
            command => '/usr/bin/pacman-db-upgrade ; /sbin/pacman -Sy',
            environment => ["http_proxy=$userland::installer::httpProxy","https_proxy=$userland::installer::httpsProxy"],
        }
    } else {
        exec { 'pacman_refresh' :
            command => '/usr/bin/pacman-db-upgrade ; /sbin/pacman -Sy',
        }
    }
}
