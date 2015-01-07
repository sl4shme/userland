class userland::ntp (
    $servers
) {
    file{ '/etc/systemd/timesyncd.conf' :
        ensure  => file,
        content => template('userland/ntp.erb'),
    }

    exec{ 'systemd_ntp' :
        command => '/usr/bin/timedatectl set-ntp true',
        unless  => '/usr/bin/timedatectl | grep "NTP enabled: yes"',
        require => File['/etc/systemd/timesyncd.conf'],
    }
}

