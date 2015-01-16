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

        file { "/home/$userland::installer::username/hpcs_vpn/" :
            ensure  => directory,
            recurse => remote,
            source  => "puppet:///modules/userland/enc/hpcs_vpn",
            owner   => "$userland::installer::username",
            group   => "$userland::installer::username",
        }

        file { "/home/$userland::installer::username/.local/bin/hpcs_vpn" :
            ensure  => link,
            target  => "/home/$userland::installer::username/hpcs_vpn/hpcs_useast.sh",
            owner   => "$userland::installer::username",
            group   => "$userland::installer::username",
        }
    }

    if $openVpn {
        ensure_packages(['openvpn'])

        file { "/home/$userland::installer::username/openvpn/" :
            ensure  => directory,
            recurse => remote,
            source  => "puppet:///modules/userland/enc/openvpn",
            owner   => "$userland::installer::username",
            group   => "$userland::installer::username",
        }

        file { "/home/$userland::installer::username/.local/bin/hp_openvpn" :
            ensure => file,
            source => "puppet:///modules/userland/hp_openvpn",
            owner  => "$userland::installer::username",
            group  => "$userland::installer::username",
            mode   => 774,
        }
    }

}
