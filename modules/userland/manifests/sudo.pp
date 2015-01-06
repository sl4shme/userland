class userland::sudo (
    $envKeepProxy = false,
    $allowWheel   = false,
    $allowYaourt  = false,
) {
    if $envKeepProxy {        
        file_line{ "proxy_http" :
            path     => '/etc/sudoers',
            ensure   => present,
            line     => 'Defaults env_keep += "http_proxy"',
            multiple => false,
            after    => 'includedir /etc/sudoers.d',
        }

        file_line{ "proxy_https" :
            path     => '/etc/sudoers',
            ensure   => present,
            line     => 'Defaults env_keep += "https_proxy"',
            multiple => false,
            after    => 'Defaults env_keep += "http_proxy"',
            require  => File_line['proxy_http'],
        }

        file_line{ "proxy_ftp" :
            path     => '/etc/sudoers',
            ensure   => present,
            line     => 'Defaults env_keep += "ftp_proxy"',
            multiple => false,
            after    => 'Defaults env_keep += "https_proxy"',
            require  => File_line['proxy_https'],
        }
    }

    if $allowWheel {
        file_line{ "sudo_wheel" :
            path     => '/etc/sudoers',
            ensure   => present,
            line     => '%wheel ALL=(ALL) ALL',
            multiple => false,
            after    => '## Uncomment to allow members of group wheel to execute any command'
        }

        file_line{ "sudo_wheel_nopass" :
            path     => '/etc/sudoers',
            ensure   => absent,
            line     => '%wheel ALL=(ALL) NOPASSWD: ALL',
        }

        file_line{ "sudo_wheel_nopass_add" :
            path     => '/etc/sudoers',
            ensure   => present,
            line     => '#%wheel ALL=(ALL) NOPASSWD: ALL',
            multiple => false,
            after    => '## Same thing without a password'
        }
    }

    if $allowYaourt {
        file_line{ "sudo_yaourt" :
            path     => '/etc/sudoers',
            ensure   => present,
            line     => 'yaourt ALL=(ALL) NOPASSWD: /usr/bin/pacman, /usr/bin/pacman-db-upgrade',
            multiple => false,
            after    => 'root ALL=(ALL) ALL',
        }
    }
}
