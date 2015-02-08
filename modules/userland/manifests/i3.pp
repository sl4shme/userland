class userland::i3 (
    $laptop        = false,
    $mainInterface 
) {
    $package = ["i3","xf86-video-nouveau","xf86-input-synaptics","xorg-server","xorg-server-utils",
                "xorg-xinit","dmenu","ttf-dejavu","feh","pulseaudio",
                "pulseaudio-alsa","alsa-utils","numlockx","gsimplecal","sysstat","imagemagick"]
    ensure_packages( $package )

    userland::aur { 'i3blocks' : 
        require => Package['i3'],
    }

    file { "/home/$userland::installer::username/.i3blocks.conf" :
        ensure  => file,
        content => template('userland/i3blocks.erb'),
        owner   => "$userland::installer::username",
        group   => "$userland::installer::username",
    }

    file { "/home/$userland::installer::username/.i3/i3datecal" :
        ensure  => file,
        source  => "puppet:///modules/userland/i3datecal",
        owner   => "$userland::installer::username",
        group   => "$userland::installer::username",
        mode    => 774,
        require => File["/home/$userland::installer::username/.i3/"],
    }

    file { "/home/$userland::installer::username/.config/gsimplecal/" :
        ensure  => directory,
        owner   => "$userland::installer::username",
        group   => "$userland::installer::username",
    }

    file { "/home/$userland::installer::username/.config/gsimplecal/config" :
        ensure  => file,
        source  => "puppet:///modules/userland/gsimplecalconf",
        owner   => "$userland::installer::username",
        group   => "$userland::installer::username",
        require => File["/home/$userland::installer::username/.config/gsimplecal/"],
    }

    file { '/usr/libexec/i3blocks/bandwitch' :
        ensure  => file,
        source  => "puppet:///modules/userland/bandwitch",
        require => Userland::Aur['i3blocks'],
    }

    file { "/home/$userland::installer::username/.i3/" :
        ensure  => directory,
        owner   => "$userland::installer::username",
        group   => "$userland::installer::username",
    }
    
    file { "/home/$userland::installer::username/.i3/config" :
        ensure  => file,
        source  => "puppet:///modules/userland/i3config",
        owner   => "$userland::installer::username",
        group   => "$userland::installer::username",
    }

    file { "/home/$userland::installer::username/.xinitrc" :
        ensure => file, 
        source => "puppet:///modules/userland/.xinitrc",
        owner  => "$userland::installer::username",
        group  => "$userland::installer::username",
    }

    file { "/usr/bin/dmenu_path" :
        ensure  => file, 
        source  => "puppet:///modules/userland/dmenu_path",
        owner   => 'root',
        group   => 'root',
        mode    => 755,
        require => Package['dmenu'], 
    }

    exec {'resize_lockscreen':
        command => '/usr/bin/convert /etc/puppet/modules/userland/files/lockscreen.png -resize `xrandr -q | awk -F\'current\' -F\',\' \'NR==1 {gsub("( |current)","");print $2}\'`\!  /etc/puppet/modules/userland/files/lockscreen_rs.png',
        creates => '/etc/puppet/modules/userland/files/lockscreen_rs.png',
        require => [Package[$package],File["/home/$userland::installer::username/.i3/"]]
    }

    file { "/home/$userland::installer::username/.i3/background.png" :
        ensure => file, 
        source => "puppet:///modules/userland/background.png",
        owner  => "$userland::installer::username",
        group  => "$userland::installer::username",
        require => File["/home/$userland::installer::username/.i3/"],
    }
    
    file { "/home/$userland::installer::username/.i3/lockscreen.png" :
        ensure => file, 
        source => "puppet:///modules/userland/lockscreen_rs.png",
        owner  => "$userland::installer::username",
        group  => "$userland::installer::username",
        require => Exec['resize_lockscreen'],
    }

}
