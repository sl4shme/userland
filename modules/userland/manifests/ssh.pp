class userland::ssh {
    service { 'sshd' :
        ensure => running,
        enable => true,
    }

    file_line{ "tcp_keep_alive" :
        path     => '/etc/ssh/sshd_config',
        ensure   => present,
        line     => 'TCPKeepAlive yes',
        multiple => false,
        match    => '.*TCPKeepAlive.*',
    }

    file_line{ "client_alive_interval" :
        path     => '/etc/ssh/sshd_config',
        ensure   => present,
        line     => 'ClientAliveInterval 0',
        multiple => false,
        match    => '.*ClientAliveInterval.*',
    }

    file_line{ "client_alive_countMax" :
        path     => '/etc/ssh/sshd_config',
        ensure   => present,
        line     => 'ClientAliveCountMax 3',
        multiple => false,
        match    => '.*ClientAliveCountMax.*',
    }
}
include userland::ssh

