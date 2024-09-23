#!/bin/bash

#SYS_SETTINGS_PATH=$(finddir B_SYSTEM_SETTINGS_DIRECTORY)/gemrb

#if [ ! -e $SYS_SETTINGS_PATH/GemRB.cfg ]; then
	#move standard dir path declaration here
#else
	#eventually read dir paths from the cfg
#fi

CACHE_PATH=$(finddir B_USER_CACHE_DIRECTORY)/gemrb
SAVE_PATH=$(finddir B_USER_SETTINGS_DIRECTORY)/gemrb

if [ ! -e $CACHE_PATH ]; then
	mkdir -p $CACHE_PATH
fi
if [ ! -e $SAVE_PATH ]; then
	mkdir -p $SAVE_PATH
fi
