class userland::hipchat_repo {
    exec {"importKey" :
        command => '/usr/bin/curl https://www.hipchat.com/keys/hipchat-linux.key | GNUPGHOME=/etc/pacman.d/gnupg gpg --import',
        unless  => '/usr/bin/cat /etc/pacman.conf | grep atlassian',
        before  => Pacman::Repo['atlassian'],
    }

    pacman::repo { 'atlassian':
        server    => 'http://downloads.hipchat.com/linux/arch/$arch',
        order     => '50',
        sig_level => 'PackageOptional DatabaseRequired TrustAll',
        before    => Exec[pacman-refresh],
    }
}
