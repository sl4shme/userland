#!/bin/bash

execPath=${0%/*}

if [ `id -u` -ne 0 ]; then
    echo "This script is intended to be run as root (no sudo)"
        exit 1
fi

echo 'Do you want to set a proxy ? [y/N]'
read resp
if [ "$resp" = "y" ] || [ "$resp" = "Y" ]; then
    echo "Enter your HTTP proxy [$http_proxy]"
    read proxy
    if [ "$proxy" = "" ]; then
        proxy="$http_proxy"
    fi
    echo "Enter your HTTPS proxy [$http_proxy]"
    read sproxy
    if [ "$sproxy" = "" ]; then
        sproxy="$http_proxy"
    fi
    export http_proxy=$proxy
    export ftp_proxy=$proxy
    export rsync_proxy=$proxy
    export https_proxy=$sproxy
    export noproxy="localhost,127.0.0.1"
    export HTTP_PROXY=$proxy
    export FTP_PROXY=$proxy
    export RSYNC_PROXY=$proxy
    export HTTPS_PROXY=$sproxy
    export NOPROXY="localhost,127.0.0.1"
fi


command -v git >/dev/null 2>&1
git=$?
if [ "$git" != "0" ]; then
    echo "Installing git"
    pacman -Sy
    pacman -S git
fi


cloned=`cat $execPath/.git/config | grep -c 'https://github.com/sl4shme/userland.git'`
if [ "$cloned" = "1" ]; then
    git clone --recursive https://github.com/sl4shme/userland.git /etc/puppet
    if [ "$?" != "0" ]; then
        exit 1
    fi
fi


command -v puppet >/dev/null 2>&1
puppet=$?
if [ "$puppet" != "0" ]; then
    echo "Installing puppet"
    pacman -Sy
    pacman -S puppet
fi


while [ -d "/etc/puppet/modules/userland/files/enc/" ]; do
    #Use this commands to encrypt :
    #cd /etc/puppet/modules/userland/files/
    #tar -cvf /etc/puppet/modules/userland/files/enc.tar.gz /enc/
    #openssl aes-256-cbc -a -salt -in /etc/puppet/modules/userland/files/enc.tar.gz -out /etc/puppet/modules/userland/files/enc.tar.gz.enc
    echo "Uncrypting your crypted folder"
    openssl aes-256-cbc -d -a -in /etc/puppet/modules/userland/files/enc.tar.gz.enc -out /etc/puppet/modules/userland/files/enc.tar.gz
    tar -xvf /etc/puppet/modules/userland/files/enc.tar.gz -C /etc/puppet/modules/userland/files/
done


confirm="n"
while [ "$confirm" != 'y' ] || [ "$confirm" != 'Y' ]; do
    if [ -a "/etc/puppet/modules/userland/manifests/installer.pp" ]; then
        echo "Found an installer file. What to do ? Edit/Use/Delete [e]"
        read resp
            case $resp in
               ""| e|E)
                    $EDITOR /etc/puppet/modules/userland/manifests/installer.pp
                    echo "Go with this file ? [N/y]"
                    read confirm
                ;;
                U|u)
                    echo "Go with this file ? [N/y]"
                    read confirm
                ;;
                D|d)
                    rm /etc/puppet/modules/userland/manifests/installer.pp
                ;;
                *)
                    echo "Wrong choice."
                ;;
            esac
    else
        echo "Generated a new installer file from example, you need to edit it."
        cp /etc/puppet/modules/userland/manifests/installer_example.pp /etc/puppet/modules/userland/manifests/installer.pp
    fi
done



#Preconfigure dans le puppet

#prevenir pour USER password

#verif perms before packaging

#set cron ? / uninstall / rm ressources

#logs

