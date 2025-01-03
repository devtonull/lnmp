#!/bin/bash
############### 
#Author: https://github.com/devtonull
#Source: https://www.modpagespeed.com/doc/build_ngx_pagespeed_from_source
#Note: Support last nginx version is 1.22.1
#bash <(wget -qO- https://raw.githubusercontent.com/devtonull/lnmp/refs/heads/main/add/add-mod-pagespeed-module.sh)

cd /root
###############
update_DEBIAN() {
    apt update && apt upgrade -y
    apt-get install build-essential zlib1g-dev libpcre3 libpcre3-dev unzip uuid-dev -y
}
update_CENTOS() {
    yum update -y
    yum upgrade -y
    yum install gcc-c++ pcre-devel zlib-devel make unzip libuuid-devel -y
}
#
install_pagespeed() {
    cd /root/lnmp2.0/src-c
    NPS_VERSION=1.13.35.2-stable
    wget -O- https://github.com/apache/incubator-pagespeed-ngx/archive/v${NPS_VERSION}.tar.gz | tar -xz
    nps_dir=$(find . -name "*pagespeed-ngx-${NPS_VERSION}" -type d)
    cd "$nps_dir"
    NPS_RELEASE_NUMBER=${NPS_VERSION/beta/}
    NPS_RELEASE_NUMBER=${NPS_VERSION/stable/}
    psol_url=https://dl.google.com/dl/page-speed/psol/${NPS_RELEASE_NUMBER}.tar.gz
    [ -e scripts/format_binary_url.sh ] && psol_url=$(scripts/format_binary_url.sh PSOL_BINARY_URL)
    wget -O- ${psol_url} | tar -xz
    cd /root/lnmp2.0
    sed -i "s:Nginx_Modules_Options=':Nginx_Modules_Options='--add-module=/root/lnmp2.0/src-c/incubator-pagespeed-ngx-1.13.35.2-stable :" lnmp.conf
    ./upgrade.sh nginx
}

if [ -f /etc/debian_version ]; then
    update_DEBIAN
    install_pagespeed
elif [ -f /etc/centos-release ]; then
    update_CENTOS
    install_pagespeed
else
    echo "Unsupported distribution."
fi
