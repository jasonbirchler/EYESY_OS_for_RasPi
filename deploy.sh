#!/bin/bash

set -ex

# Add pi user to tty
sudo usermod -a -G tty pi

# Update apt
sudo apt update

# Add nodejs 
sudo apt install -y nodejs npm

# Debian packages
sudo apt install -y python3-pygame python3-liblo python3-alsaaudio python3-pip libffi-dev nodejs

# Python packages
sudo apt install -y python3-psutil python3-cherrypy3 python3-numpy python3-jack-client

# Node packages
cd web/node && npm install && cd ../..

# Move service files into place and make sure perms are set correctly.
sudo chmod 644 systemd/*
sudo cp systemd/* /etc/systemd/system

# Move PD into place.
#cp pd/externals/*.pd_linux ../../pdexternals

# Reload services.
sudo systemctl daemon-reload

# Put the Eyesy_Norns one folder up for a cleaner Sidekick menu
#rm -rf ../Eyesy_Norns
#cp -rf Eyesy_Norns ..

cd /home/pi/Eyesy
./install_pd.sh

wget https://raw.githubusercontent.com/openframeworks/openFrameworks/patch-release/scripts/linux/debian/install_dependencies.sh
wget https://raw.githubusercontent.com/openframeworks/openFrameworks/patch-release/scripts/linux/debian/install_codecs.sh
chmod 755 install_dependencies.sh 
chmod 755 install_codecs.sh 
sudo ./install_dependencies.sh && sudo ./install_codecs.sh
sudo rm install_dependencies.sh
sudo rm install_codecs.sh
