class userland::installer {
stage { 'pacman':
    before => Stage['pacman_refresh'],
}
stage { 'pacman_refresh' :
    before => Stage['main'],
}
stage { 'package':
    require => Stage['main'],
}
stage { 'post':
    require => Stage['package'],
}

###############################################################################
###############################################################################

##
#Generic parameters
##
$username = "" #Name of the non-root user


##
#Distant server parameters
#Used for alias, other configuration, and set as env vars permanently in zsh.
##

$mainSshServ = ""
$mainSshUser = ""
$mainSshPort = ""


##
#Configure permanent Proxy
##

$httpProxy=""
$httpsProxy=""
#class {'userland::permanent_proxy' : }

##
#Manage Sudoers
##

#class {'userland::sudo' :
#    envKeepProxy => false,
#    allowWheel   => false,
#    allowYaourt  => false,
#    stage        => 'pacman',
#}


##
#Configure Pacman and Yaourt
##

#class {'userland::package_manager' :
#    installYaourt   => false, #Require sudo allowYaourt and encKeepProxy
#    iLoveCandy      => false,
#    enableCore      => true, 
#    enableExtra     => true, 
#    enableCommunity => true, 
#    enableMultilib  => false,
#    stage           => 'pacman'
#}


##
#Refresh Pacman database on every run
##

#class {'userland::pacman_refresh': }


##
#Configure User
#Wont configure password
##

#class {'userland::config_user' :
#    username         => $username,
#    manageUserSshKey => false,
#    manageRootSshKey => false,
#}


##
#Install packages
#Those ones don't need yaourt
##

#class {'userland::packages' :
#    base         => true,
#    dev          => false,
#    network      => false,
#    multimedia   => false,
#    graphicalApp => false,
#    rdp          => false,
#    stage        => 'package',
#}


##
#Install firefox
##

#class { 'userland::firefox' :
#    flashplayer => false,
#    gtalk       => false, # Require yaourt
#    stage        => 'package',
#}


##
#Ssh daemon
##

#class { 'userland::ssh' :
#    stage        => 'package',
#}


##
#Install Vim
##

#class {'userland::vim' :
#    forUser => false,
#    forRoot => false,
#    stage   => 'package',
#}


##
#Install Zsh
##

#class {'userland::zsh' :
#    forUser => false,
#    forRoot => false,
#    stage   => package,
#}


##
#Deactivate system beep
##

#class {'userland::rm_beep' : }


##
#Install Hipchat
#Require userland::package_manager
##

#class {'userland::hipchat_repo' : 
#    stage => 'pacman',
#}
#class {'userland::hipchat' :
#    stage => 'package',
#}


##
#Install Terminator
##

#class {'userland::terminator' :
#    stage => 'package',
#}


##
#Laptop specific ressources
##

#class {'userland::laptop' :
#    wicd  => true,
#    e6400 => true,
#    stage => 'package',
#}


##
#Cups and printer install
##

#class {'userland::printer' :
#    hpConfig => false,
#    stage    => 'package',
#}


##
#I3 installation and configuration
#Require yaourt
##

#class {'userland::i3' :
#    mainInterface => "", #network interface for ip monitoring
#    laptop        => false,
#    stage         => 'package',
#}


##
#Smuxi client installation and configuration
##

#class {'userland::smuxi_client' :
#    sshKey     => "", #Leave commented for default
#    sshUser    => "", #Leave commented for default
#    sshHost    => "", #Leave commented for default
#    sshPort    => "", #Leave commented for default
#    engineUser => "",
#    enginePass => "",
#    engineName => "",
#    stage      => 'package',
#}


##
#VPN HP
##

#class {'userland::hp_vpns' :
#    juniper => false,  # require multilib and yaourt
#    openVpn => false,
#    stage   => 'package',
#}


##
#VirtualBox
##

#class {'userland::vbox' :
#    stage => 'package',
#}


##
#Torrent client
##

#class {'userland::torrent' :
#    stage => 'package',
#}


##
#Install KVM
##

#class {'userland::kvm' :
#    interfaceToBridge => "", # If not set, no Bridge
#    stage => 'package',
#}


##
#Configure NTP
#Servers : list of ntp servers, space separated
##

#class {'userland::ntp' :
#    servers => "0.arch.pool.ntp.org 1.arch.pool.ntp.org 2.arch.pool.ntp.org 3.arch.pool.ntp.org",
#}


##
#Configure Git settings
##

#class {'userland::git' :
#    username => "",
#    email    => "",
#    forRoot  => true,
#    forUser  => true,
#    stage    => 'package',
#}


##
#Cleanup
##

#class {'userland::clean' :
#    stage => 'post',
#}


}
include userland::installer
