#!/bin/sh

settingsDir="$(finddir B_USER_SETTINGS_DIRECTORY)/MidiSynth/"

pluginsSysDataDir="$(finddir B_SYSTEM_DATA_DIRECTORY)/MidiSynth"
pluginsUserDataDir="$(finddir B_USER_DATA_DIRECTORY)/MidiSynth"

mkdir -p $settingsDir

if [ -d "$pluginsSysDataDir/KeyMappings" ]; then
	cp -rfn "$pluginsSysDataDir/KeyMappings" "$settingsDir"
	cp -a "$pluginsSysDataDir/Chords" "$settingsDir"
elif [ -d "$pluginsUserDataDir/KeyMappings" ]; then
	cp -rfn "$pluginsUserDataDir/KeyMappings" "$settingsDir"
	cp -a "$pluginsUserDataDir/Chords" "$settingsDir"
else
	exit 1 # couldn't find KeyMappings and Chords
fi
