# Lnmp
Lnmp

<h2>Install:</h2>
<br>
<b>#Debian 9+ / CentOS 7+</b><br>
<pre>
bash <(wget -qO- https://raw.githubusercontent.com/devtonull/lnmp/refs/heads/main/install.sh)
</pre>
<br>
<br>
<!-- <h2>Add</h2>
<hr>
<pre>
cd /usr/local
git clone https://github.com/FRiCKLE/ngx_cache_purge.git
git clone https://github.com/yaoweibin/ngx_http_substitutions_filter_module
git clone https://github.com/openresty/headers-more-nginx-module
git clone https://github.com/yaoweibin/nginx_upstream_check_module
wget https://raw.githubusercontent.com/devtonull/lnmp/refs/heads/main/nginx.sh
\cp nginx.sh lnmp1.8/include/
cd /root/lnmp1.8
sed -i "s:Nginx_Modules_Options='':Nginx_Modules_Options='--add-module=/usr/local/ngx_http_substitutions_filter_module --add-module=/usr/local/ngx_cache_purge --add-module=/usr/local/headers-more-nginx-module --add-module=/usr/local/nginx_upstream_check_module':" lnmp.conf
./upgrade.sh nginx
#Enter a new Nginx verson number
#http://nginx.org/
</pre>
<br> -->
<h2>Source</h2>
<hr>
https://github.com/licess/lnmp
<br>
<h2>Related fixes</h2>
<hr>
<pre>
#make: bison: Command not found
https://askubuntu.com/questions/557629/how-to-install-flex-and-bison-error-can-not-locate-file
#Command 'make' not found
https://itsfoss.com/make-command-not-found-ubuntu/
</pre>
