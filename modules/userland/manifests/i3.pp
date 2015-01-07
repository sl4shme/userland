class userland::i3 (
    $laptop        = false,
    $mainInterface 
) {
    $package = ["i3","xf86-video-nouveau","xorg-server","xorg-server-utils",
                "xorg-xinit","dmenu","ttf-dejavu","feh","pulseaudio",
                "pulseaudio-alsa","alsa-utils","parcellite","numlockx","gsimplecal","sysstat"]
    package { $package :
        ensure => installed,
    }

    userland::aur { 'i3blocks' : 
        require => Package['i3'],
    }

    file { "/home/$userland::installer::username/.i3blocks.conf" :
        ensure  => file,
        content => template('userland/i3blocks.erb'),
        owner   => "$userland::installer::username",
        group   => "$userland::installer::username",
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
        recurse => remote,
        source  => "puppet:///modules/userland/.i3",
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
}
