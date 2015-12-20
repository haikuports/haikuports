#!/bin/sh

settingsDir="$(finddir B_USER_SETTINGS_DIRECTORY)"

recibeSysDataDir="$(finddir B_SYSTEM_DATA_DIRECTORY)"
recibeUserDataDir="$(finddir B_USER_DATA_DIRECTORY)"
recibesFileBase="recibe/recipes.db.zip"

if [ -f "$settingsDir/recipes.db" ]; then
	exit 0 # already have a recipes database
fi

if [ -f "$recibeSysDataDir/$recibesFileBase" ]; then
	recipesZipFile="$recibeSysDataDir/$recibesFileBase"
elif [ -f "$recibeUserDataDir/$recibesFileBase" ]; then
	recipesZipFile="$recibeUserDataDir/$recibesFileBase"
else
	exit 1 # couldn't find recipes.db
fi

cd "$settingsDir"
unzip "$recipesZipFile"
