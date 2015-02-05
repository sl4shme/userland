class userland::laptop (
    $wicd      = false,
    $e6400     = false,
    $bluetooth = false,
) {

    if $wicd {
        ensure_packages(['wicd'])

        service {'wicd.service' :
            ensure  => running,
            enable  => true,
            require => Package['wicd'],
        }
    }

    if $e6400 {
        file { "/home/$userland::installer::username/.local/bin/unthrottle" :
            ensure => file,
            mode   => 774,
            owner  => "$userland::installer::username",
            group  => "$userland::installer::username",
            source => "puppet:///modules/userland/unthrottle.sh",
        }

        file { "/home/$userland::installer::username/.local/bin/e6400_temp" :
            ensure => file,
            mode   => 774,
            owner  => "$userland::installer::username",
            group  => "$userland::installer::username",
            source => "puppet:///modules/userland/temp.sh",
        }

        userland::aur { 'msr-tools':
            require => File["/home/$userland::installer::username/.local/bin/unthrottle"],
        }

        package { 'lm_sensors' :
            ensure => installed,
        }
    }

    if $bluetooth {
        $list1 = ["pulseaudio-alsa","bluez","bluez-libs","bluez-utils","bluez-firmware"]
        ensure_packages($list1)

        file { '/etc/modules-load.d/btusb.conf': 
            ensure  => file,                       
            owner   => "root",                     
            group   => "root",                     
            content => 'btusb',                  
        }                                          

        exec { 'modprobe_bluetooth':
            command => '/sbin/modprobe btusb',
            unless  => '/usr/bin/lsmod | grep btusb',
            require => Package[$list1],
        }

        service { 'bluetooth' :
            ensure  => running,
            enable  => true,
            require => Exec['modprobe_bluetooth'],
        }

        file { '/etc/udev/rules.d/97-bluetooth-hid2hci.rules' :
            ensure => file,
            source => "puppet:///modules/userland/hid2hci.rules",
            owner  => 'root',
            group  => 'root',
            mode   => 644,
            before => Exec['modprobe_bluetooth'],
        }

        file { "/home/$userland::installer::username/.local/bin/jambox" :
            ensure  => file,
            mode    => 774,
            owner   => "$userland::installer::username",
            group   => "$userland::installer::username",
            source  => "puppet:///modules/userland/jambox",
            require => Service['bluetooth'],
        }
    }
}
