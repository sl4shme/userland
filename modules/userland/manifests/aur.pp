define userland::aur(
    $ensure = 'present',
) {
    case $ensure {
        'present': {
            exec { "aur::install::${name}":
                command   => "/usr/bin/su aur -lc 'export http_proxy=$userland::installer::httpProxy ; export https_proxy=$userland::installer::httpsProxy ; packer -S --noconfirm ${name}'",
                unless    => "/sbin/pacman -Qk ${name}",
                logoutput => 'on_failure',
                timeout   => 0,
            }
        }
        'absent': {
            exec { "aur::remove::${name}":
                command   => "/sbin/pacman -Rs --noconfirm ${name}",
                onlyif    => "/sbin/pacman -Qi ${name}",
                logoutput => 'on_failure',
            }
        }
        default: {
            fail("Aur[${name}] ensure parameter must be either 'present' or 'absent'")
        }
    }
}
