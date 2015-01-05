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
        $list = ["tmux","wget","unzip","git","openssl","mlocate","lsof","most","openssh"]
        package { $list :
            ensure => installed,
        }
    }
    if $dev {
        $list1 = ["python","python-pip","flake8"]
        package { $list1 :
            ensure => installed,
        }
    }
    if $network {
        $list2 = ["nmap","tcpdump","openbsd-netcat","dnsutils","net-tools"]
        package { $list2 :
            ensure => installed,
        }
    }
    if $multimedia {
        $list3 = ["vlc","libreoffice"]
        package { $list3 :
            ensure => installed,
        }
    }
     if $graphicalApp {
        $list4 = ["xarchiver","pcmanfm","xorg-xcalc","gedit","imagemagick","gvfs","gvfs-mtp","gvfs-afc"]
        package { $list4 :
            ensure => installed,
        }
    }
   if $rdp {
        $list5 = ["freerdp","remmina"]
        package { $list5 :
            ensure => installed,
        }
    }
}
