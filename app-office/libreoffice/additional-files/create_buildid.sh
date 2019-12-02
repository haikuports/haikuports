#/bin/sh

mkdir -p /boot/home/config/settings/LibreOffice/4/user/extensions

echo `head -5 /system/apps/LibreOffice/program/versionrc | awk -F "=" '/buildid/ {print $2}'` > \
~/config/settings/LibreOffice/4/user/extensions/buildid
