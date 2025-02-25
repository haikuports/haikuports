#!/bin/sh

# Create the mariadb system tables 
/system/apps/MariaDB/scripts/mariadb-install-db --user=user --datadir=/boot/home/config/var/mariadb/data/ --auth-root-authentication-method=normal

# Notify the user 
notify --icon /system/kernel_`uname -p` "MariaDB system tables created"
