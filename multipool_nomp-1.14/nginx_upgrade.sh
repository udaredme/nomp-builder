#!/usr/bin/env bash
#####################################################
# Created by cryptopool.builders for crypto use...
#####################################################

source /etc/functions.sh
source /etc/multipool.conf
source $STORAGE_ROOT/nomp/.nomp.conf

# NGINX upgrade
echo -e " Upgrading NGINX...$COL_RESET"

#Grab Nginx key and proper mainline package for distro
echo "deb http://nginx.org/packages/mainline/ubuntu `lsb_release -cs` nginx" \
    | sudo tee /etc/apt/sources.list.d/nginx.list >/dev/null 2>&1

sudo curl -fsSL https://nginx.org/keys/nginx_signing.key | sudo apt-key add - > /dev/null 2>&1
hide_output sudo apt-get update
apt_install nginx

# Make additional conf directories, move and generate needed configurations.
sudo mkdir -p /etc/nginx/cryptopool.builders
sudo mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.old
sudo cp -r nginx_confs/nginx.conf /etc/nginx/
sudo cp -r nginx_confs/general.conf /etc/nginx/cryptopool.builders
sudo cp -r nginx_confs/proxy.conf /etc/nginx/cryptopool.builders
sudo cp -r nginx_confs/security.conf /etc/nginx/cryptopool.builders
sudo cp -r nginx_confs/letsencrypt.conf /etc/nginx/cryptopool.builders

# Removing default nginx site configs.
sudo rm -r /etc/nginx/conf.d/default.conf
sudo rm -r /etc/nginx/sites-available/default
sudo rm -r /etc/nginx/sites-enabled/default

restart_service nginx
echo -e "$GREEN NGINX upgrade complete...$COL_RESET"
cd $HOME/multipool/nomp
