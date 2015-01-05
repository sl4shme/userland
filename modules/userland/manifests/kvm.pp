class userland::kvm (
    $interfaceToBridge = false,
) {
    if interfaceToBridge {
        package { ["bridge-utils","netctl"] :
            ensure => installed,
        }

        file { '/etc/netctl/bridge' :
            ensure  => file,
            content => template('userland/bridge.erb'),
            require => Package['netctl'],
        }

        service { "dhcpcd@$interfaceToBridge.service" :
            ensure => stopped,
            enable => false,
        }

        service { 'netctl@bridge.service' :
#            ensure => running,
            enable => true,
            require => File['/etc/netctl/bridge']
        }
    }

    package { ["qemu","virt-manager"] :
        ensure => installed,
    }

    exec { 'modprobe_virtio':
        command => '/sbin/modprobe virtio',
        unless  => '/usr/bin/lsmod | grep virtio',
        require => Package['qemu']
    }

    exec { 'modprobe_kvm':
        command => '/sbin/modprobe kvm',
        unless  => '/usr/bin/lsmod | grep kvm',
        require => Package['qemu']
    }

    file { '/etc/modules-load.d/virtio.conf':
        ensure  => file,
        owner   => "root",
        group   => "root",
        content => 'virtio',
        require => Package['qemu'],
    }

    file { '/etc/modules-load.d/kvm.conf':
        ensure  => file,
        owner   => "root",
        group   => "root",
        content => 'kvm',
        require => Package['qemu'],
    }

    service { 'libvirtd' :
        ensure => running,
        enable => true,
        require => File['/etc/modules-load.d/virtio.conf']
    }

    file { '/etc/polkit-1/rules.d/50-org.libvirt.unix.manage.rules' :
        ensure => file,
        source => "puppet:///modules/userland/libvirt_rules",
    }

}
