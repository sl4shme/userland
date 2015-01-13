class userland::cron {
    cron { 'puppet_run':
        command => '/usr/bin/puppet apply /etc/puppet/modules/userland/manifests/installer.pp 2>&1 >> /var/log/puppet/installer.log',
        user    => 'root',
        minute  => 0,
        hour    => 1,
        month   => '*',
        weekday => '*',
    }
}

