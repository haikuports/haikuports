#!/bin/bash

wad="$(finddir B_SYSTEM_DATA_DIRECTORY)/gzdoom/chex3.wad"
cmd=""

if [ ! -e $wad ]; then
	wad="$(finddir B_USER_DATA_DIRECTORY)/gzdoom/chex3.wad"
	if [ ! -e $wad ]; then
		alert --stop "Game data not found!"
		exit 1
	fi
fi

if [ $(command -v GZDoom) ]; then
	cmd="GZDoom"
	echo "GZDoom v4 detected"
elif [ -e $(finddir B_SYSTEM_APPS_DIRECTORY)/GZDoom/GZDoom ]; then
	cmd="$(finddir B_SYSTEM_APPS_DIRECTORY)/GZDoom/GZDoom"
	echo "Legacy GZDoom found in system"
elif [ -e $(finddir B_USER_APPS_DIRECTORY)/GZDoom/GZDoom ]; then
	cmd="$(finddir B_USER_APPS_DIRECTORY)/GZDoom/GZDoom"
	echo "Legacy GZDoom found in home"
else
	alert --stop "GZDoom binary not found!"
	exit 1
fi

$cmd -iwad $wad $@
