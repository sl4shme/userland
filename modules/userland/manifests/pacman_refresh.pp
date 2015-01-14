class userland::pacman_refresh {
    exec { 'pacman_refresh' :
        command => '/usr/bin/pacman-db-upograde ; /sbin/pacman -Sy',
        environment => ["http_proxy=$userland::installer::httpProxy","https_proxy=$userland::installer::httpsProxy"],
    }
}
