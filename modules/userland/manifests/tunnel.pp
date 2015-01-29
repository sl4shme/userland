class userland::tunnel (
    $sshKey  = "/home/$userland::installer::username/.ssh/id_rsa",
    $sshUser = $userland::installer::mainSshServUser,
    $sshHost = $userland::installer::mainSshServ,
    $sshPort = $userland::installer::mainSshServPort,
    $remotePort,
) {
    file { '/usr/bin/tunnelscript' :
        ensure => file,
        owner  => 'root',
        group  => 'root',
        mode   => 755,
        source => "puppet:///modules/userland/tunnelscript",
    }

    file { '/usr/lib/systemd/system/tunneler@.service' :
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => 744,
        source  => "puppet:///modules/userland/tunneler@.service",
        require => File['/usr/bin/tunnelscript'],
    }

    $string="$sshHost%$sshUser%$sshPort%$remotePort%$sshKey"

    service { "tunneler@$string" :
        ensure  => running,
        enable => true,
        require => File['/usr/lib/systemd/system/tunneler@.service'],
    }
}
