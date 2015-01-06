class userland::firefox (
    $flashplayer = false,
    $gtalk       = false,
) {
    package { 'firefox' :
        ensure => installed,
    }

    if $flashplayer {
        package { ["libvdpau","flashplugin"] :
            ensure => installed,
        }
    }

    if $gtalk {
       userland::aur { 'google-talkplugin' : }
    }
}


