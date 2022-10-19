#!/bin/sh

settingsDir="$(finddir B_USER_SETTINGS_DIRECTORY)"

configSysDataDir="$(finddir B_SYSTEM_DATA_DIRECTORY)/haiku-format"
configUserDataDir="$(finddir B_USER_DATA_DIRECTORY)/haiku-format"

if [ -e "$configSysDataDir/.haiku-format" ]; then
	cp -a "$configSysDataDir/.haiku-format" "$settingsDir"
elif [ -e "$configUserDataDir/.haiku-format" ]; then
	cp -a "$configUserDataDir/.haiku-format" "$settingsDir"
else
	exit 1 # couldn't find .haiku-format
fi

chmod +w "$settingsDir/.haiku-format"
