#!/bin/sh
mkdir -p ~/config/settings/fatelk/yoshi/commands
datadir=`finddir B_SYSTEM_DATA_DIRECTORY`
cd $datadir/yoshi
cp -r * ~/config/settings/fatelk/yoshi
cp Example/* ~/config/settings/fatelk/yoshi/commands
