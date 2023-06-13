#!/bin/bash

settingsDir="$(finddir B_USER_SETTINGS_DIRECTORY)/cudatext"
dataDir="$(finddir B_SYSTEM_DATA_DIRECTORY)/cudatext/settings_default"

mkdir -p $settingsDir
cp -rf "$dataDir" "$settingsDir"
