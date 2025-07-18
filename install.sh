#!/bin/bash
###############
#Author: https://github.com/devtonull
#Source: https://github.com/lnmpkvemail/lnmp
###############
lnmp_ver="2.0"
CheckIinstallType="$1"
get_install_tar() {
    if [ "${CheckIinstallType}" = "offline" ]; then
        CheckMirror="n"
        wget https://src.wola.work/lnmp/lnmp${lnmp_ver}-full.tar.gz -cO lnmp${lnmp_ver}-full.tar.gz && tar zxf lnmp${lnmp_ver}-full.tar.gz && mv lnmp${lnmp_ver}-full lnmp${lnmp_ver}
        # wget https://github.com/jwsky/lnmp-full-safe/releases/download/publish/lnmp${lnmp_ver}-full.tar.gz -cO lnmp${lnmp_ver}-full.tar.gz && tar zxf lnmp${lnmp_ver}-full.tar.gz && mv lnmp${lnmp_ver}-full lnmp${lnmp_ver}
    else
        wget https://github.com/devtonull/lnmp/raw/main/lnmp${lnmp_ver}.1.tar.gz -cO lnmp${lnmp_ver}.1.tar.gz && tar zxf lnmp${lnmp_ver}.1.tar.gz
    fi
}
rM=$(($RANDOM % 59))
# rH=$(($RANDOM % 11))
hour_range=(5 6 7 13 14 15 21 22 23)
rH=${hour_range[$RANDOM % ${#hour_range[@]}]}
rD=$(shuf -i 2-5 -n 1)
\cp /etc/hosts /etc/hosts.bak
mkdir /home/cacheroot

# # Check system
if [ -f /etc/debian_version ]; then
    update_install() {
        apt update && apt upgrade -y
        apt install curl wget zip unzip git lsof ufw net-tools iftop rsync -y
    }
    set_crontab() {
        # echo '#/etc/init.d/cron restart' >>/var/spool/cron/crontabs/root
        # echo '#'$((rM)) $((rH)) "* * * /sbin/reboot" >>/var/spool/cron/crontabs/root && /etc/init.d/cron restart
        (crontab -l; echo "# ${rM} ${rH} */${rD} * * /sbin/reboot") | crontab -
        (crontab -l; echo "# /etc/init.d/cron restart") | crontab -
    }
elif [ -f /etc/centos-release ]; then
    update_install() {
        yum update -y && yum upgrade -y
        yum install epel-release curl wget zip unzip git lsof ufw net-tools iftop rsync luarocks -y
        echo 'v /tmp 1777 root root 3d' >/etc/tmpfiles.d/custom-tmp.conf
        systemd-tmpfiles --clean >/dev/null 2>&1 &
    }
    set_crontab() {
        # echo '#/sbin/service crond start' >>/var/spool/cron/root
        # echo '#'$((rM)) $((rH)) "* * * /sbin/reboot" >>/var/spool/cron/root && /sbin/service crond start
        (crontab -l; echo "# ${rM} ${rH} */${rD} * * /sbin/reboot") | crontab -
        (crontab -l; echo "# /sbin/service crond start") | crontab -
    }
else
    echo "This install script only support Debian or CentOS."
    exit
fi

get_source_file() {
    cd /root
    # # get script file
    # wget https://github.com/devtonull/lnmp/raw/main/lnmp${lnmp_ver}.1.tar.gz -cO lnmp${lnmp_ver}.1.tar.gz && tar zxf lnmp${lnmp_ver}.1.tar.gz
    get_install_tar
    # # get module file
    mkdir /root/lnmp${lnmp_ver}/src-c
    cd /root/lnmp${lnmp_ver}/src-c
    # git clone https://github.com/FRiCKLE/ngx_cache_purge
    # git clone https://github.com/yaoweibin/ngx_http_substitutions_filter_module
    # git clone https://github.com/openresty/headers-more-nginx-module
    # git clone https://github.com/yaoweibin/nginx_upstream_check_module
    # git clone https://github.com/replay/ngx_http_lower_upper_case
    git clone https://github.com/devtonull/ngx_cache_purge
    git clone https://github.com/devtonull/ngx_http_substitutions_filter_module
    git clone https://github.com/devtonull/headers-more-nginx-module
    git clone https://github.com/devtonull/nginx_upstream_check_module
    git clone https://github.com/devtonull/ngx_http_lower_upper_case
    git clone https://github.com/devtonull/ngx_http_proxy_connect_module
    # # set replace
    wget https://raw.githubusercontent.com/devtonull/lnmp/refs/heads/main/change/fail2ban.sh -O /root/lnmp${lnmp_ver}/tools
    wget https://raw.githubusercontent.com/devtonull/lnmp/refs/heads/main/change/version.sh -O /root/lnmp${lnmp_ver}/include/version.sh
    wget https://raw.githubusercontent.com/devtonull/lnmp/refs/heads/main/change/nginx.sh -O /root/lnmp${lnmp_ver}/include/nginx.sh
    wget https://raw.githubusercontent.com/devtonull/lnmp/refs/heads/main/change/upgrade_nginx.sh -O /root/lnmp${lnmp_ver}/include/upgrade_nginx.sh
    wget https://raw.githubusercontent.com/devtonull/lnmp/refs/heads/main/change/lnmp.conf -O /root/lnmp${lnmp_ver}/lnmp.conf
}

install_fail2ban() {
    # # install fail2ban
    cd /root/lnmp${lnmp_ver}/tools
    echo "Install fail2ban..."
    . fail2ban.sh
    sleep 5s
}

install_lnmp() {
    # # install lnmp
    cd /root/lnmp${lnmp_ver}
    chmod +x *.sh
    echo "Choose install:"
    echo ""
    echo " 1: Install full LNMP"
    echo " 2: Install full LAMP"
    echo " 3: Install full LNMPA"
    echo " 4: Only install Nginx"
    echo " 5: Only install DB"
    echo ""
    read -p "(Directly Enter to cancel), Enter 1 or 2,3,4,5:" install
    if [[ '1' = "$install" ]]; then
        eval "./install.sh lnmp"
    elif [[ '2' = "$install" ]]; then
        eval "./install.sh lamp"
    elif [[ '3' = "$install" ]]; then
        eval "./install.sh lnmpa"
    elif [[ '4' = "$install" ]]; then
        eval "./install.sh nginx"
    elif [[ '5' = "$install" ]]; then
        eval "./install.sh db"
    else
        echo "Install canceled."
        exit
    fi
}

install_luajit() {
    echo "LuaJIT could not be found."
    echo "Install luajit2-2.1-20230119..."
    if [[ ! -d "/root/lnmp2.0/src/luajit2-2.1-20230119" ]]; then
        cd /root/lnmp2.0/src
        gzip -d luajit2-2.1-20230119.tar.gz
        tar -xf luajit2-2.1-20230119.tar
    fi
    cd /root/lnmp2.0/src/luajit2-2.1-20230119
    make
    sleep 5
    make install
    luajit -v
}
install_luarocks() {
    apt install luarocks -y
    luarocks install lua-cjson
    luarocks install lua-resty-redis
}

set_ufw() {
    if [ -f /etc/centos-release ]; then
        if systemctl list-unit-files | grep -qw firewalld.service; then
            echo "Disable firewalld ..."
            sleep 3
            systemctl stop firewalld
            systemctl disable firewalld
            systemctl mask firewalld
            systemctl status firewalld
            sleep 3
        fi
        ufw --force enable
        ufw default deny incoming
        ufw default allow outgoing
        ufw allow ssh
        ufw allow http
        ufw allow https
        ufw status verbose
        wget https://raw.githubusercontent.com/devtonull/lnmp/refs/heads/main/add/etc/init.d/autoufw -O /etc/init.d/autoufw
        chmod +x /etc/init.d/autoufw
        chkconfig --add autoufw
        chkconfig autoufw on

    else
        ufw --force enable
        ufw default deny incoming
        ufw default allow outgoing
        ufw allow ssh
        ufw allow http
        ufw allow https
        ufw status verbose
        systemctl disable netfilter-persistent
        systemctl start ufw
        systemctl enable ufw
    fi
}

set_lnmp_checker() {
    wget https://raw.githubusercontent.com/devtonull/lnmp/refs/heads/main/add/etc/init.d/lnmp_checker -O /etc/init.d/lnmp_checker
    if [ -f /etc/centos-release ]; then
        chmod +x /etc/init.d/lnmp_checker
        chkconfig --add lnmp_checker
        chkconfig lnmp_checker on

    else
        chmod +x /etc/init.d/lnmp_checker
        update-rc.d lnmp_checker defaults
    fi
}

deny_ip_access() {
    # # deny ip:80
    echo "deny ip:80..."
    wget https://raw.githubusercontent.com/devtonull/lnmp/refs/heads/main/change/nginx.conf -O /usr/local/nginx/conf/nginx.conf
    local_ip=$(hostname -I | awk '{print $1}')
    sed -i "s#server_name _;#server_name ${local_ip};#g" /usr/local/nginx/conf/nginx.conf
}

change_mysql_cnf() {
    # # set mysql directory
    if [[ -f /etc/my.cnf ]]; then
        mkdir /home/dataroot
        cp -R /usr/local/mysql/var /home/dataroot
        chown -R mysql:mysql /home/dataroot
        chmod -R 755 /home/dataroot
        cp /etc/my.cnf /etc/my.cnf.bak
        wget https://raw.githubusercontent.com/devtonull/lnmp/refs/heads/main/change/my.cnf -O /etc/my.cnf
    else
        echo 'MySQL is not install.'
    fi
}

change_php_ini() {
    # # set mysql directory
    if [[ -f /usr/local/php/etc/php.ini ]]; then
        cp /usr/local/php/etc/php.ini /usr/local/php/etc/php.ini.bak
        wget https://raw.githubusercontent.com/devtonull/lnmp/refs/heads/main/change/php.ini -O /usr/local/php/etc/php.ini
    else
        echo 'PHP is not install.'
    fi
}

# # install
update_install
get_source_file
install_fail2ban
install_lnmp
install_luajit
install_luarocks

# # set
set_crontab
set_ufw
set_lnmp_checker
deny_ip_access
change_mysql_cnf
change_php_ini

# # done
lnmp restart
