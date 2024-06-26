#!/bin/sh

# Create the nginx user if it doesn't exist
if ! id "nginx" &>/dev/null; then
	useradd -d /system/settings/nginx/ -s /bin/false -n "nginx user" nginx
	notify --icon /system/kernel_`uname -p` \
		"Created user: nginx"
fi

# Create the nginx group if it doesn't exist
if ! grep -q -E "^nginx:" /etc/group; then
	groupadd nginx
	notify --group nginx \
		--icon /system/kernel_`uname -p` \
		"Created group: nginx"
fi

mkdir -p var/www/nginx

if [ ! -e var/www/nginx/index.nginx.html ]; then
	ln -s @DOCDIR@/html/index.html var/www/nginx/index.nginx.html
fi

if [ ! -e var/www/nginx/50x.html ]; then
	ln -s @DOCDIR@/html/50x.html var/www/nginx
fi

chmod -R 775 var/www/nginx
chown -R nginx:nginx var/www/nginx 

mkdir -p var/log/nginx var/tmp/nginx var/nginx

mkdir -p var/run
