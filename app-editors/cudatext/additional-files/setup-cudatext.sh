#!/bin/bash

settingsDir="$(finddir B_SYSTEM_DATA_DIRECTORY)/cudatext/settings_default"
installSettingsDir="$(finddir B_USER_SETTINGS_DIRECTORY)/cudatext"
dataDir="$(finddir B_SYSTEM_DATA_DIRECTORY)/cudatext/data"
installDataDir="$(finddir B_USER_NONPACKAGED_DATA_DIRECTORY)/cudatext"
pyDir="$(finddir B_SYSTEM_DATA_DIRECTORY)/cudatext/py"

mkdir -p $installSettingsDir $installDataDir
cp -rf "$settingsDir" "$installSettingsDir"
cp -rf "$dataDir" "$installDataDir"
cp -rf "$pyDir" "$installDataDir"
