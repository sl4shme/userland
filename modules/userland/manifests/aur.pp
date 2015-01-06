define userland::aur(
    $ensure = 'present',
) {
    case $ensure {
        'present': {
            exec { "aur::install::${name}":
                command   => "/usr/bin/yaourt -S --noconfirm ${name}",
                unless    => "/usr/bin/yaourt -Qk ${name}",
                logoutput => 'on_failure',
            }
        }
        'absent': {
            exec { "aur::remove::${name}":
                command   => "/usr/bin/yaourt -Rs ${name}",
                onlyif    => "/usr/bin/yaourt -Qi ${name}",
                logoutput => 'on_failure',
            }
        }
        default: {
            fail("Pacman::Aur[${name}] ensure parameter must be either 'present' or 'absent'")
        }
    }
}
