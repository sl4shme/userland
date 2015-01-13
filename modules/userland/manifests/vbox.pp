class userland::vbox {
    ensure_packages(["virtualbox","virtualbox-host-modules","virtualbox","qt4"])

    exec { 'modprobe':                               
        command => '/sbin/modprobe vboxdrv',       
        unless  => '/usr/bin/lsmod | grep vboxdrv' 
    }         

    file { '/etc/modules-load.d/vboxdrv.conf':         
        ensure  => file,                          
        owner   => "root",                        
        group   => "root",                        
        content => 'vboxdrv',            
    }                                             


}
