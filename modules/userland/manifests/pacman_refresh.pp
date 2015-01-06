class userland::pacman_refresh {
    exec { 'pacman_refresh' :
        command => '/sbin/pacman -Sy'
    }
}
