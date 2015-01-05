class userland::clean {
    exec { 'recursiveChown' :
        command => "/usr/bin/chown -R $userland::installer::username:$userland::installer::username /home/$userland::installer::username/",
        }

    #file {"/home/$userland::installer::username/" :
        #ensure  => directory,
        #recurse => true,
        #purge   => false,
        #owner   => "$userland::installer::username",
        #group   => "$userland::installer::username",
    #}
}
