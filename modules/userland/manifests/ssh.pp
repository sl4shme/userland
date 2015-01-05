class userland::ssh {
    service { 'sshd' :             
        ensure => running,         
            enable => true,            
    }                              
}
