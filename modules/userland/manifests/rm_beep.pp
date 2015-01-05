class userland::rm_beep {
    exec { 'rmmod':
        command => '/usr/bin/rmmod pcspkr',
        onlyif  => '/usr/bin/lsmod | grep pcspkr'
    }
    file { '/etc/modprobe.d/nobeep.conf':
        ensure  => file,
        mode    => 774,
        owner   => "root",
        group   => "root",
        content => 'blacklist pcspkr',
    }
}
