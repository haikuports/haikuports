#!/bin/sh
mkdir -p /boot/home/yab_work/BuildFactory

cp -R /boot/system/apps/yab-buildfactory/* /boot/home/yab_work/BuildFactory
chmod 777 /boot/home/yab_work/BuildFactory/BeSly_Buildfactory.yab
chmod 777 /boot/home/yab_work/BuildFactory/BuildFactory.yab
chmod -R 777 /boot/home/yab_work/BuildFactory/compress
