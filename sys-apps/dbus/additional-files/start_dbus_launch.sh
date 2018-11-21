#/bin/sh

eval `dbus-launch --auto-syntax`

if grep -q dbus-launch /boot/home/config/settings/boot/UserBootscript
then
    exit 0
else
    echo 'eval `dbus-launch --auto-syntax`' >> /boot/home/config/settings/boot/UserBootscript
fi