class userland::firefox (
    $flashplayer = false,
    $gtalk       = false,
) {
    ensure_packages(['firefox'])
    
    if $flashplayer {
        ensure_packages(["libvdpau","flashplugin"])
    }

    if $gtalk {
        userland::aur { 'google-talkplugin' : 
            require => Package['Firefox'],
        }
    }
}


