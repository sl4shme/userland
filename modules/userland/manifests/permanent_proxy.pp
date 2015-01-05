class userland::permanent_proxy {
    file { '/tmp/test':
        ensure  => file,
        content => template('userland/permanent_proxy.erb'),
        mode    => '755',
    }
}
