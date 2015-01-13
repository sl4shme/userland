class userland::printer (
    $hpConfig = false,
) {
    ensure_packages(["cups","libcups","hplip"])
    
    service { 'org.cups.cupsd.service' :
        ensure  => running,
        enable  => true,
        require => Package['cups'],
    }

    file {'/var/spool/cups/tmp/' :
        ensure => directory,
        mode   => 644,
    }

    if $hpConfig {
        file { '/etc/cups/printers.conf' :
            ensure => file,
            source  => "puppet:///modules/userland/printers.conf",
            require => Package['cups'],
        }
    }
}
