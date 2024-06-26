#! /bin/sh

settingsDir="$(finddir B_USER_SETTINGS_DIRECTORY)"

systemConfig="$(finddir B_SYSTEM_SETTINGS_DIRECTORY)/gerbera"

mkdir -p $settingsDir

if [ -d "$systemConfig" ]; then
	mv "$systemConfig" "$settingsDir"
else
	exit 1 #couldn't find $systemConfig
fi
