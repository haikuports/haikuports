#!/bin/bash

gamedir=$(dirname $(realpath $0))
if [ -z "$AQUARIA_DATA_PATH" ]; then
	exec $gamedir/AquariaLauncher
	exit
fi

settingsDir="`finddir B_USER_SETTINGS_DIRECTORY`"

mkdir -p $settingsDir/Aquaria/preferences
cp -n $gamedir/default_usersettings.xml $settingsDir/Aquaria/preferences/usersettings.xml
cp -rf $gamedir/files/* $AQUARIA_DATA_PATH

cd $gamedir
exec ./Aquaria
