#!/bin/sh

USER_SETTINGS_DIR="`finddir B_USER_SETTINGS_DIRECTORY`"

if ! [ -d $USER_SETTINGS_DIR/Thunderbird ]; then
	if [ -d $USER_SETTINGS_DIR/thunderbird ]; then
		mv $USER_SETTINGS_DIR/thunderbird $USER_SETTINGS_DIR/Thunderbird
	fi
fi
