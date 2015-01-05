class userland::package_manager(
    $installYaourt  = false,
    $iLoveCandy     = false,
    $enableMultilib = false,
) {
    if $enableMultilib{
        $repositories = {
            'core'      => { order => '10', },
            'extra'     => { order => '20', },
            'community' => { order => '30', },
            'multilib'  => { order => '40', },
        }
    }
    else {
         $repositories = {
            'core'      => { order => '10', },
            'extra'     => { order => '20', },
            'community' => { order => '30', },
        }
    }
    class { 'pacman':
        repositories => $repositories,
        iLoveCandy   => $iLoveCandy
    }

    if $installYaourt{
       class {"pacman::yaourt" : }
    }
}

