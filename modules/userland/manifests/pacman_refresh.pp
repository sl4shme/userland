class userland::pacman_refresh {
    exec { 'pacman_refresh' :
        command => '/usr/bin/pacman-db-upgrade ; /sbin/pacman -Sy',
        environment => ["http_proxy=$userland::installer::httpProxy","https_proxy=$userland::installer::httpsProxy"],
    }
}
