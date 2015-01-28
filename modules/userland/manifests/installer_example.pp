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
$username = "" #Name of the non-root user (Principally used to calculate home path)


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
#    allowAur     => false,
#    stage        => 'pacman',
#}


##
#Configure Pacman and AUR helper
##

#class {'userland::package_manager' :
#    installPacker   => false, #Require sudo allowAur and envKeepProxy
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

#class {'userland::pacman_refresh':
#    stage => 'pacman_refresh',
#}


##
#Configure User
#Wont configure password
##

#class {'userland::config_user' : # If not set, a lot of things won't work
#    username         => $username, #If not set no user managment
#    manageUserSshKey => false,  #require files in enc/.ssh
#    manageRootSshKey => false,  #require files in enc/.ssh
#    manageUserPgp    => false,  #require files in enc/.gnupg
#    manageRootPgp    => false,  #require files in enc/.gnupg
#    userSshAuthKey   => false,  #require files in enc/.ssh
#    rootSshAuthKey   => false,  #require files in enc/.ssh
#}


##
#Configure Password store
##

#class {'userland::pass' :
#   $pgpKeyId    = "",   
#   $repoAddress = "",   
#   $forRoot     = false,
#   $forUser     = false,
#   $passmenu    = false,
#}


##
#Install packages
#Those ones don't need aur
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
#    gtalk       => false, # Require aur
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
#Require aur
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
#    juniper => false,  # require multilib and aur
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
#Will overwrite your .gitconfig
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


##
#Run this manifest daily at 1am
##

#class {'userland::cron' :
#    stage => 'post',
#}

}
include userland::installer
