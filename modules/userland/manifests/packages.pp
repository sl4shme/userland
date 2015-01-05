class userland::packages (
    $base         = true,
    $dev          = false,
    $network      = false,
    $firefox      = false,
    $multimedia   = false,
    $graphicalApp = false,
    $rdp          = false,
) {
    if $base {
        $list = ["tmux","wget","unzip","git","openssl","curl","mlocate","lsof","most","openssh"]
        package { $list :
            ensure => installed,
        }
    }
    if $dev {
        $list = ["python","python-pip","flake8"]
        package { $list :
            ensure => installed,
        }
    }
    if $network {
        $list = ["nmap","tcpdump","openbsd-netcat","dnsutils","net-tools"]
        package { $list :
            ensure => installed,
        }
    }
    if $multimedia {
        $list = ["vlc","libreoffice"]
        package { $list :
            ensure => installed,
        }
    }
     if $graphicalApp {
        $list = ["xarchiver","pcmanfm","xorg-xcalc","gedit","imagemagick","gvfs","gvfs-mtp","gvfs-afc"]
        package { $list :
            ensure => installed,
        }
    }
   if $rdp {
        $list = ["freerdp","remmina"]
        package { $list :
            ensure => installed,
        }
    }
}
