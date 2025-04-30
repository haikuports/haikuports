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
else
	if [ -e $(finddir B_SYSTEM_APPS_DIRECTORY)/GZDoom/GZDoom ]; then
		cmd="$(finddir B_SYSTEM_APPS_DIRECTORY)/GZDoom/GZDoom"
	elif [ -e $(finddir B_USER_APPS_DIRECTORY)/GZDoom/GZDoom ]; then
		cmd="$(finddir B_USER_APPS_DIRECTORY)/GZDoom/GZDoom"
	fi
fi

if [ "$cmd" = "" ]; then
	alert --stop "GZDoom binary not found!"
	exit 1
fi

$cmd -iwad $wad $@
