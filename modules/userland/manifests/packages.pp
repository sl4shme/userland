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
        $list = ["base-devel","tmux","wget","unzip","git","openssl","mlocate","lsof","most","openssh","curl","libqalculate"]
        ensure_packages($list)
    }
    if $dev {
        $list1 = ["python","python-pip","flake8"]
        ensure_packages($list1)
    }
    if $network {
        $list2 = ["nmap","tcpdump","openbsd-netcat","dnsutils","net-tools"]
        ensure_packages($list2)
    }
    if $multimedia {
        $list3 = ["vlc","libreoffice-fresh"]
        ensure_packages($list3)
    }
     if $graphicalApp {
        $list4 = ["xarchiver","pcmanfm","xorg-xcalc","gedit","imagemagick","gvfs","gvfs-mtp","gvfs-afc"]
        ensure_packages($list4)
    }
   if $rdp {
        $list5 = ["freerdp","remmina"]
        ensure_packages($list5)
    }
}
