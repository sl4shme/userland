define userland::other_repo (
    $repoName,
    $repoServer,
    $sigLevel = "Required DatabaseOptional",
) {
    file_line{ "$repoName.comment" :
        path     => '/etc/pacman.d/otherRepo',
        ensure   => present,
        line     => "#Repo ${repoName}",
        multiple => false,
        require  => File['/etc/pacman.d/otherRepo'],
    }

    file_line{ "$repoName" :
        path     => '/etc/pacman.d/otherRepo',
        ensure   => present,
        line     => "[${repoName}]",
        multiple => false,
        after    => "#Repo ${repoName}",
        require  => File_line["$repoName.comment"],
    }

    file_line{ "$repoName.server" :
        path     => '/etc/pacman.d/otherRepo',
        ensure   => present,
        line     => "Server = ${repoServer}",
        multiple => false,
        after    => "\\\\[${repoName}]",
        require  => File_line["$repoName"],
    }

    file_line{ "$repoName.sigLevel" :
        path     => '/etc/pacman.d/otherRepo',
        ensure   => present,
        line     => "SigLevel = ${sigLevel}",
        multiple => false,
        after    => "Server = ${repoServer}",
        require  => File_line["$repoName.server"],
    }
}
