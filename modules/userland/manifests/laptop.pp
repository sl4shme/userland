class userland::laptop (
    $wicd  = false,
    $e6400 = false,
) {

    if $wicd {
        package { 'wicd' :
            ensure => installed,
        }

        service {'wicd.service' :
            ensure  => running,
            enable  => true,
            require => Package['wicd'],
        }
    }

    if $e6400 {
        file { "/home/$userland::installer::username/.local/bin/unthrottle" :
            ensure => file,
            mode   => 774,
            owner  => "$userland::installer::username",
            group  => "$userland::installer::username",
            source => "puppet:///modules/userland/unthrottle.sh",
        }

        file { "/home/$userland::installer::username/.local/bin/e6400_temp" : 
            ensure => file,                                                   
            mode   => 774,                                                    
            owner  => "$userland::installer::username",                       
            group  => "$userland::installer::username",                       
            source => "puppet:///modules/userland/temp.sh",             
        }                                                                     
    
        pacman::aur { 'msr-tools': 
            require => File["/home/$userland::installer::username/.local/bin/unthrottle"],
        }
        
        package { 'lm_sensors' :
            ensure => installed,
        }
    }        
}
