define userland::aur(
    $ensure = 'present',
) {
    case $ensure {
        'present': {
            exec { "aur::install::${name}":
                command   => "/usr/bin/su aur -lc 'export http_proxy=$userland::installer::httpProxy ; export https_proxy=$userland::installer::httpsProxy ; packer -S --noconfirm ${name}'",
                unless    => "pacman -Qk ${name}",
                logoutput => 'on_failure',
            }
        }
        'absent': {
            exec { "aur::remove::${name}":
                command   => "pacman -Rs --noconfirm ${name}",
                onlyif    => "pacman -Qi ${name}",
                logoutput => 'on_failure',
            }
        }
        default: {
            fail("Aur[${name}] ensure parameter must be either 'present' or 'absent'")
        }
    }
}
