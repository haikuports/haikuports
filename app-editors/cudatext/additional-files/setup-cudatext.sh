#!/bin/bash

settingsDir="$(finddir B_USER_SETTINGS_DIRECTORY)/"
dataDir="$(finddir B_SYSTEM_DATA_DIRECTORY)/cudatext/"

mkdir -p $settingsDir
cp -rf "$dataDir" "$settingsDir"
