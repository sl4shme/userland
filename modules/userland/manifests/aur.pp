define userland::aur(
    $ensure = 'present',
) {
    case $ensure {
        'present': {
            exec { "aur::install::${name}":
                command   => "/usr/bin/su yaourt -lc 'export http_proxy=$userland::installer::httpProxy ; export https_proxy=$userland::installer::httpsProxy ; yaourt -S --noconfirm ${name}'",
                unless    => "/usr/bin/su yaourt -lc 'export http_proxy=$userland::installer::httpProxy ; export https_proxy=$userland::installer::httpsProxy ; yaourt -Qk ${name}'",
                logoutput => 'on_failure',
            }
        }
        'absent': {
            exec { "aur::remove::${name}":
                command   => "/usr/bin/su yaourt -lc 'export http_proxy=$userland::installer::httpProxy ; export https_proxy=$userland::installer::httpsProxy ; yaourt -Rs ${name}'",
                onlyif    => "/usr/bin/su yaourt -lc 'export http_proxy=$userland::installer::httpProxy ; export https_proxy=$userland::installer::httpsProxy ; yaourt -Qi ${name}'",
                logoutput => 'on_failure',
            }
        }
        default: {
            fail("Pacman::Aur[${name}] ensure parameter must be either 'present' or 'absent'")
        }
    }
}
