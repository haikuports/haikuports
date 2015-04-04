#!/bin/sh

settingsDir="$(finddir B_USER_SETTINGS_DIRECTORY)/FilWip/"

pluginsSysDataDir="$(finddir B_SYSTEM_DATA_DIRECTORY)/FilWip"
pluginsUserDataDir="$(finddir B_USER_DATA_DIRECTORY)/FilWip"

if [ -d "$settingsDir/Plugins" ]; then
	exit 0 # already has Plugins folder
fi

mkdir -p $settingsDir

if [ -d "$pluginsSysDataDir/Plugins" ]; then
	cp -rf $pluginsSysDataDir/Plugins "$settingsDir"
elif [ -d "$pluginsUserDataDir/Plugins" ]; then
	cp -rf $pluginsUserDataDir/Plugins "$settingsDir"
else
	exit 1 # couldn't find Plugins
fi
