####bash                                   
#proxy ?                                   
    #export http_proxy=$proxy             
    #export ftp_proxy=$proxy              
    #export rsync_proxy=$proxy            
    #export https_proxy=$proxy            
    #export noproxy="localhost,127.0.0.1" 
    #export HTTP_PROXY=$proxy             
    #export FTP_PROXY=$proxy              
    #export RSYNC_PROXY=$proxy            
    #export HTTPS_PROXY=$proxy            
    #export NOPROXY="localhost,127.0.0.1" 
#Preconfigure dans le puppet 
#http and https

#prevenir pour USER password

#verif root                                
    #if [ `id -u` -ne 0 ]; then                                    
        #echo "This script is intended to be run as root (no sudo)"
        #if [ "$bproot" != "true" ]; then                          
            #exit 1                                                
        #fi                                                        
    #fi                                                            




    #dechiffrement de userland/files/enc en enc.tar.gz puis detar directement dans file/enc/
        #Use command to encrypt : openssl aes-256-cbc -a -salt -in secrets.txt -out secrets.txt.enc
                #openssl aes-256-cbc -d -a -in $resd/sshkey.tar.gz.enc -out $resd/sshkey.tar.gz
                        #tar -xf $resd/sshkey.tar.gz -C $resd/                                   



    #verif perms before packaging
    
#set cron ? / uninstall / rm ressources    
#logs                                      

