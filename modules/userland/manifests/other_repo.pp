define userland::other_repo (
    $name,
    $server,
    $sigLevel = "Required DatabaseOptional",
) {

    file_line{ "$name.comment" :
        path     => '/etc/pacman.d/otherRepo',
        ensure   => present,
        line     => "#Repo ${name}",
        multiple => false,
        require  => File['/etc/pacman.d/otherRepo'],
    }

    file_line{ "$name" :
        path     => '/etc/pacman.d/otherRepo',
        ensure   => present,
        line     => "[${name}]",
        multiple => false,
        after    => "#Repo ${name}",
        require  => File_line["$name.comment"],
    }

    file_line{ "$name.server" :
        path     => '/etc/pacman.d/otherRepo',
        ensure   => present,
        line     => "Server = ${server}",
        multiple => false,
        after    => "\[${name}]",
        require  => File_line["$name"],
    }

    file_line{ "$name.sigLevel" :
        path     => '/etc/pacman.d/otherRepo',
        ensure   => present,
        line     => "SigLevel = ${sigLevel}",
        multiple => false,
        after    => "Server = ${server}",
        require  => File_line["$name.server"],
    }
}
