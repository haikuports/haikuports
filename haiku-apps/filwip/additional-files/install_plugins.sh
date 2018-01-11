#!/bin/sh

settingsDir="$(finddir B_USER_SETTINGS_DIRECTORY)/FilWip/"

pluginsSysDataDir="$(finddir B_SYSTEM_DATA_DIRECTORY)/FilWip"
pluginsUserDataDir="$(finddir B_USER_DATA_DIRECTORY)/FilWip"

mkdir -p $settingsDir

if [ -d "$pluginsSysDataDir/Plugins" ]; then
	cp -rfn "$pluginsSysDataDir/Plugins" "$settingsDir"
elif [ -d "$pluginsUserDataDir/Plugins" ]; then
	cp -rfn "$pluginsUserDataDir/Plugins" "$settingsDir"
else
	exit 1 # couldn't find Plugins
fi
