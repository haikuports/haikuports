#!/bin/bash

wad="$(finddir B_SYSTEM_DATA_DIRECTORY)/doomdata/chex3.wad"

if [ ! -e $wad ]; then
	wad="$(finddir B_USER_DATA_DIRECTORY)/doomdata/chex3.wad"
	if [ ! -e $wad ]; then
		alert --stop "Game data not found!"
		exit 1
	fi
fi

# UZDoom > GZDoom
if [ $(command -v UZDoom) ]; then
	cmd="UZDoom"
	echo "UZDoom detected"
elif [ $(command -v GZDoom) ]; then
	cmd="GZDoom"
	echo "GZDoom v4 detected"
fi

# LZDoom is set as a secondary option if modern UZDoom/GZDoom is present
# And takes precedence over legacy GZDoom (x86)
if [ $(command -v LZDoom) ]; then
	if [ "$cmd" = "" ]; then
		cmd="LZDoom"
	else
		cmd2="LZDoom"
	fi
	echo "LZDoom detected"
elif [ "$cmd" = "" ]; then
	if [ -e $(finddir B_SYSTEM_APPS_DIRECTORY)/GZDoom/GZDoom ]; then
		cmd="$(finddir B_SYSTEM_APPS_DIRECTORY)/GZDoom/GZDoom"
		echo "Legacy GZDoom found in system"
	elif [ -e $(finddir B_USER_APPS_DIRECTORY)/GZDoom/GZDoom ]; then
		cmd="$(finddir B_USER_APPS_DIRECTORY)/GZDoom/GZDoom"
		echo "Legacy GZDoom found in home"
	fi
fi

if [ "$cmd" = "" ]; then
	alert --stop "ZDoom-compatible binary not found!"
	exit 1
fi

# This will only show up on 64bit, legacy GZDoom is skipped on purpose (and its $cmd would mess up the dialog)
if [ "$cmd2" = "LZDoom" ]; then
	cmd=$(alert --idea "Multiple ZDoom source ports detected. Choose one to use with Chex Quest 3" "$cmd" "$cmd2")
fi

$cmd -iwad $wad $@
