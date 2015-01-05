class userland::hipchat {
    package { ["hipchat","gstreamer0.10-base-plugins","gstreamer0.10"] :
        ensure  => installed,
    }
}
