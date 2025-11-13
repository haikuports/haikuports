#!/bin/bash

k4data=$(finddir B_SYSTEM_DATA_DIRECTORY)/omnispeak/keen4

if [ ! -e $k4data ]; then
	k4data=$(finddir B_USER_DATA_DIRECTORY)/omnispeak/keen4
	if [ ! -e $k4data ]; then
		alert --stop "Game data not found!"
		exit 1
	fi
fi

omnispeak /GAMEPATH $k4data $@