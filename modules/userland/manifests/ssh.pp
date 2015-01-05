class userlan::ssh {
    service { 'sshd' :             
        ensure => running,         
            enable => true,            
    }                              
}
