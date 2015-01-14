class userland::hipchat_repo {
    exec {"importKey" :
        command => '/usr/bin/curl https://www.hipchat.com/keys/hipchat-linux.key | GNUPGHOME=/etc/pacman.d/gnupg gpg --import',
        unless  => '/usr/bin/cat /etc/pacman.d/otherRepo | grep atlassian',
        before  => Userland::Other_repo['atlassian'],
    }

    userland::other_repo { 'atlassian' :
        repoName     => "atlassian",
        repoServer   => 'http://downloads.hipchat.com/linux/arch/$arch',
        sigLevel => 'PackageOptional DatabaseRequired TrustAll'
    }
}
