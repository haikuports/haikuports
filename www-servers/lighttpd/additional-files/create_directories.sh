#!/bin/sh

mkdir -p var/www/htdocs

if [ ! -e var/www/htdocs/index.shtml ]; then
	ln -s /system/data/lighttpd/www/htdocs/index.shtml var/www/htdocs
fi

if [ ! -e var/www/htdocs/index.lighttpd.html ]; then
	ln -s /system/data/lighttpd/www/htdocs/index.lighttpd.html var/www/htdocs
fi

mkdir -p var/log/lighttpd var/lib/lighttpd var/cache/lighttpd
