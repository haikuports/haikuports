#!/bin/sh
dataDir=`finddir B_SYSTEM_DATA_DIRECTORY`
pluginDir=`finddir B_USER_SETTINGS_DIRECTORY`
mkdir -p ~/config/settings/nnn/plugins
ln -sf $dataDir/nnn/plugins/* $pluginDir/nnn/plugins
ln -sf $dataDir/nnn/plugins/.nnn-plugin-helper $pluginDir/nnn/plugins
