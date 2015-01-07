class userland::permanent_proxy {
    file { '/etc/profile.d/proxy.sh':
        ensure  => file,
        content => template('userland/permanent_proxy.erb'),
        mode    => '755',
    }
}
