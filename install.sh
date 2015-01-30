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
    pacman-db-upgrade
    pacman -Sy
    pacman -S git --noconfirm
fi


cloned=`cat /etc/puppet/.git/config | grep -c 'https://github.com/sl4shme/userland.git'`
if [ "$cloned" != "1" ]; then
    git clone --recursive https://github.com/sl4shme/userland.git /etc/puppet
    if [ "$?" != "0" ]; then
        exit 1
    fi
fi


command -v puppet >/dev/null 2>&1
puppet=$?
if [ "$puppet" != "0" ]; then
    echo "Installing puppet"
    pacman-db-upgrade
    pacman -Sy
    pacman -S puppet --noconfirm
fi

if [ ! -f "/usr/bin/sudo" ]; then
    echo "Installing sudo"
    pacman-db-upgrade
    pacman -Sy
    pacman -S sudo --noconfirm
fi

#Use this commands to encrypt :
#cd /etc/puppet/modules/userland/files/
#tar -cvf /etc/puppet/modules/userland/files/enc.tar.gz enc/
#openssl aes-256-cbc -a -salt -in /etc/puppet/modules/userland/files/enc.tar.gz -out /etc/puppet/modules/userland/files/enc.tar.gz.enc

if [ ! -d "/etc/puppet/modules/userland/files/perso" ]; then
    echo "Do you want to clone the personal repo ? [Y/n]"
    read resp
    if [ "$resp" = "y" ] || [ "$resp" = "Y" ] || [ "$resp" = "" ]; then
        git clone git@git.plop.in:/home/git/perso.git /etc/puppet/modules/userland/files/perso
    else
        echo "Depending on what you want to install and configure, the folder /etc/puppet/modules/userland/files/enc/ should contain : "
        echo "id_rsa and id_rsa.pub files"
        echo ".gnupg folder"
        echo "openvpn folder"
        echo "smuxi-engine.ini"
    fi
fi

while [ -f "/etc/puppet/modules/userland/files/perso/perso.tar.gz.enc" ] && [ ! -f "/etc/puppet/modules/userland/files/perso/perso.tar.gz" ]; do
    echo "Found a perso encrypted archive. Decrypt it ? [Y/n]"
    read resp
    if [ "$resp" = "y" ] || [ "$resp" = "Y" ] || [ "$resp" = "" ]; then
        openssl aes-256-cbc -d -a -in /etc/puppet/modules/userland/files/perso/perso.tar.gz.enc -out /etc/puppet/modules/userland/files/perso/perso.tar.gz ; persocode=$?
        if [ "$persocode" -eq "0" ] ; then
            tar -xf /etc/puppet/modules/userland/files/perso/perso.tar.gz -C /etc/puppet/modules/userland/files/
        else
            rm -f /etc/puppet/modules/userland/files/perso/perso.tar.gz
        fi
    else
        break
    fi
done

while [ -f "/etc/puppet/modules/userland/files/hp.tar.gz.enc" ] && [ ! -f "/etc/puppet/modules/userland/files/hp.tar.gz" ]; do
    echo "Found an encrypted VPN archive (needed for Juniper VPN). Decrypt it ? [Y/n]"
    read resp
    if [ "$resp" = "y" ] || [ "$resp" = "Y" ] || [ "$resp" = "" ]; then
        openssl aes-256-cbc -d -a -in /etc/puppet/modules/userland/files/hp.tar.gz.enc -out /etc/puppet/modules/userland/files/hp.tar.gz ; hpcode=$?
        if [ "$hpcode" -eq "0"  ] ; then
            tar -xf /etc/puppet/modules/userland/files/hp.tar.gz -C /etc/puppet/modules/userland/files/
        else
            rm -f /etc/puppet/modules/userland/files/hp.tar.gz
        fi
    else
        break
    fi
done

confirm="n"
while [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; do
    if [ -a "/etc/puppet/modules/userland/manifests/installer.pp" ]; then
        echo "Found an installer file. What to do ? Edit/Use/Delete [e]"
        read resp
            case $resp in
               ""| e|E)
                    nano /etc/puppet/modules/userland/manifests/installer.pp
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
        sed -i "s#\$httpProxy=\"\"#\$httpProxy=\"$proxy\"#" /etc/puppet/modules/userland/manifests/installer.pp
        sed -i "s#\$httpsProxy=\"\"#\$httpsProxy=\"$sproxy\"#" /etc/puppet/modules/userland/manifests/installer.pp
    fi
done

mkdir /var/log/puppet 2> /dev/null
touch /var/log/puppet/installer.log
puppetCode="6"
retry="0"
while [ "$puppetCode" -gt "2" ]; do
    puppet apply /etc/puppet/modules/userland/manifests/installer.pp --detailed-exitcodes 2>&1 | tee -a /var/log/puppet/installer.log
    puppetCode=$PIPESTATUS
    retry=$((retry + 1))
    if [ "$retry" -eq 3 ]; then
        echo "Puppet finished with error or warning three times in a row, You should look a the log in /var/log/puppet/installer.log"
        break
    fi
done

username=`cat /etc/puppet/modules/userland/manifests/installer.pp | grep '$username =' |cut -d '"' -f 2`
if [[ $(cat /etc/shadow | grep "$username" | cut -d ':' -f 2) = "!" ]]; then
    echo "You should set a password for user $username"
    passwd $username
fi

echo 'Do you want to remove Puppet and its files (except the installer.pp) ? [y/N]'
read respRm
if [ "$respRm" = "y" ] || [ "$respRm" = "Y" ]; then
    pacman -Rs puppet --noconfirm
    cp etc/puppet/modules/userland/manifests/installer.pp /etc/puppet/
    rm -rf /etc/puppet/modules
fi
