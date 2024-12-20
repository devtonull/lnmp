#!/bin/bash
############### 
#Author: https://github.com/devtonull
#Source: https://github.com/openresty/sregex
#bash <(wget -qO- https://raw.githubusercontent.com/devtonull/lnmp/refs/heads/main/add/add-mod-replace-filter-nginx-module.sh)
###############
##
#make install sregex
cd /root/lnmp2.0/src-c
git clone https://github.com/openresty/sregex
cd /root/lnmp2.0/src-c/sregex
echo 'Waiting make install sregex...'
make
sleep 5s
make install
if [ ! -f "libsregex.so.0" ];then
  echo "No libsregex.so.0 file"
  exit
fi
ls

#ldd $(which /usr/local/nginx/sbin/nginx)
if [ -f /etc/debian_version ]; then
    cp /root/lnmp2.0/src-c/sregex/libsregex.so.0 /lib/x86_64-linux-gnu/
elif [ -f /etc/centos-release ]; then
    cp /root/lnmp2.0/src-c/sregex/libsregex.so.0 /usr/lib64
else
    echo "Unsupported distribution."
fi

sleep 5s
#get replace-filter-nginx-module
cd /root/lnmp2.0/src-c
git clone https://github.com/openresty/replace-filter-nginx-module
#Re-install nginx
cd /root/lnmp2.0
sed -i "s:Nginx_Modules_Options=':Nginx_Modules_Options='--add-module=/root/lnmp2.0/src-c/replace-filter-nginx-module :" lnmp.conf
chmod +x *.sh
echo 'Re-install Nginx to support "replace-filter-nginx-module"'
./upgrade.sh nginx
