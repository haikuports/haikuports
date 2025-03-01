#!/bin/sh

# create mysqld directory 
mkdir -p /var/run/mysqld
chmod 755 /var/run/mysqld

# Check if /var/mysql already contains a MariaDB database
if [ -f "/var/mysql/ibdata1" ]; then
    notify --icon /system/kernel_`uname -p` "MariaDB already exists in /var/mysql"
else
    # Create the MariaDB system tables
    /system/bin/mariadb-install-db --user=user --datadir=/var/mysql --auth-root-authentication-method=normal

    # Notify the user
    notify --icon /system/kernel_`uname -p` "MariaDB system tables have been created"

    # Show an alert to read the README file
    alert "MariaDB installation is finished, please restart your system and check the README-INSTALL instructions to complete the setup." "OK"

fi

