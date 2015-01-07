#!/bin/bash
mkdir /tmp/juniper
cd /tmp/juniper 
wget http://effbot.org/media/downloads/elementtree-1.2.6-20050316.tar.gz
tar -xvf elementtree-1.2.6-20050316.tar.gz
cd elementtree-1.2.6-20050316
python2 setup.py install
wget http://effbot.org/media/downloads/elementtidy-1.0-20050212.zip
unzip elementtidy-1.0-20050212.zip
cd elementtidy-1.0-20050212
python2  setup.py install
rm -rf /tmp/juniper
