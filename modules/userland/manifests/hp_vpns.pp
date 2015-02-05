class userland::hp_vpns (
    $juniper = false,
    $openVpn = false,
) {
    if $juniper {
        ensure_packages( ["lib32-zlib","lib32-glibc","python2-pexpect","net-tools"])

        file  { '/tmp/depinstall.sh' :
            ensure => file,
            mode   => 774,
            source => "puppet:///modules/userland/depinstall.sh",
        }
        
        if $userland::installer::http_proxy != '' { 
            exec { 'install_juniper_deps':
                command     => "/tmp/depinstall.sh",
                unless      => '/usr/bin/ls /usr/lib/python2.7/site-packages/ | grep -c elementtidy',
                environment => ["http_proxy=$userland::installer::httpProxy","https_proxy=$userland::installer::httpsProxy"],
                require     => File['/tmp/depinstall.sh'],
            }
        } else {
            exec { 'install_juniper_deps':
                command     => "/tmp/depinstall.sh",
                unless      => '/usr/bin/ls /usr/lib/python2.7/site-packages/ | grep -c elementtidy',
                require     => File['/tmp/depinstall.sh'],
            }
        }

        file { "/etc/hpcs_vpn/" :
            ensure  => directory,
            recurse => remote,
            source  => "puppet:///modules/userland/enc/hpcs_vpn",
            owner   => "root",
            group   => "root",
        }
    }

    if $openVpn {
        ensure_packages(['openvpn'])

        file { "/etc/openvpn/" :
            ensure  => directory,
            recurse => remote,
            source  => "puppet:///modules/userland/enc/openvpn",
            owner   => "root",
            group   => "root",
        }
    }

}
