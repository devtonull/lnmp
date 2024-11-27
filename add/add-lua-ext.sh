#!/bin/bash
###############
#Author: https://github.com/devtonull
#bash <(wget -qO- https://raw.githubusercontent.com/devtonull/lnmp/refs/heads/main/add/add-lua-ext.sh)
###############

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

if ! command -v luajit &>/dev/null; then
    install_luajit
    install_luarocks
else
    luajit -v
fi
# if ! command -v luarocks &>/dev/null; then
#     install_luarocks
# fi
