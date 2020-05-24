#!/bin/sh
mkdir -p /boot/home/yab_work/BuildFactory

cp -R /boot/system/apps/yab-buildfactory/* /boot/home/yab_work/BuildFactory
chmod 777 /boot/home/yab_work/BuildFactory/BeSly_Buildfactory.yab
chmod 777 /boot/home/yab_work/BuildFactory/BuildFactory.yab
chmod -R 777 /boot/home/yab_work/BuildFactory/compress
#cd /boot/home/yab_work/BuildFactory/; wget https://github.com/lorglas/yab/archive/1.7.8.zip; unzip 1.7.8.zip; cp yab-1.7.8/* ./;chmod -R 777 *

