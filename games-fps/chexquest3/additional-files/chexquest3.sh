#!/bin/bash

wad="$(finddir B_SYSTEM_DATA_DIRECTORY)/gzdoom/chex3.wad"

if [ ! -e $wad ]; then
	wad="$(finddir B_USER_DATA_DIRECTORY)/gzdoom/chex3.wad"
	if [ ! -e $wad ]; then
		alert --stop "Game data not found!"
		exit 1
	fi
fi

GZDoom -iwad $wad $@
