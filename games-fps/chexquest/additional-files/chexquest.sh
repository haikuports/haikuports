#!/bin/bash

wad="$(finddir B_SYSTEM_DATA_DIRECTORY)/doomdata/chex.wad"
chex2wad="$(finddir B_SYSTEM_DATA_DIRECTORY)/doomdata/chex2.wad"

if [ ! -e $wad ]; then
	wad="$(finddir B_USER_DATA_DIRECTORY)/doomdata/chex.wad"
	chex2wad="$(finddir B_USER_DATA_DIRECTORY)/doomdata/chex2.wad"
	if [ ! -e $wad ]; then
		alert --stop "Game data not found!"
		exit 1
	fi
fi

if [ "$1" = "1" ]; then
	wadname="Chex Quest"
	echo "$wadname selected"
elif [ "$1" = "2" ]; then
	pwad="-file $chex2wad"
	wadname="Chex Quest 2"
	echo "$wadname selected"
fi

if [ $(command -v chocolate-doom) ]; then
	port1="chocolate-doom"
	port1name="Chocolate Doom"
	echo "Chocolate Doom detected"
fi

if [ $(command -v GZDoom) ]; then
	if [ "$port1" = "" ]; then
		port1="GZDoom"
		port1name=$port1
	elif [ "$port2" = "" ]; then
		port2="GZDoom"
		port2name=$port2
	fi
	echo "GZDoom detected"
fi

if [ -e $(finddir B_SYSTEM_APPS_DIRECTORY)/GZDoom/GZDoom ]; then
	if [ "$port1" = "" ]; then
		port1="$(finddir B_SYSTEM_APPS_DIRECTORY)/GZDoom/GZDoom"
		port1name="GZDoom (Legacy)"
	elif [ "$port2" = "" ]; then
		port2="$(finddir B_SYSTEM_APPS_DIRECTORY)/GZDoom/GZDoom"
		port2name="GZDoom (Legacy)"
	fi
	echo "GZDoom (Legacy) detected"
fi

if [ $(command -v prboom-plus) ]; then
	if [ "$port1" = "" ]; then
		port1="prboom-plus"
		port1name="PrBoom+"
	elif [ "$port2" = "" ]; then
		port2="prboom-plus"
		port2name="PrBoom+"
	elif [ "$port3" = "" ]; then
		port3="prboom-plus"
		port3name="PrBoom+"
	fi
	echo "PrBoom+ detected"
fi

if [ "$port1" = "" ]; then
	alert --stop "No Doom source port detected!"
else
	if [ "$wadname" = "" ]; then
		askwad=$(alert --idea "Choose between Chex Quest and Chex Quest 2" "Chex Quest" "Chex Quest 2")
		if [ "$askwad" = "Chex Quest 2" ]; then
			pwad="-file $chex2wad"
		fi
		wadname=$askwad
		echo "$wadname selected"
	fi
	if [ "$port2" = "" ]; then
		echo "Only one port detected, running it by default"
		$port1 -iwad $wad $pwad $@
	else
		askport="Multiple Doom source ports detected. Choose one to use with '$wadname'"
		if [ "$port3" = "" ]; then
			button=$(alert --idea "$askport" "$port1name" "$port2name")
		else
			button=$(alert --idea "$askport" "$port1name" "$port2name" "$port3name")
		fi
		echo "$button selected"
		if [ "$button" = "$port1name" ]; then
			$port1 -iwad $wad $pwad $@
		elif [ "$button" = "$port2name" ]; then
			$port2 -iwad $wad $pwad $@
		elif [ "$button" = "$port3name" ]; then
			$port3 -iwad $wad $pwad $@
		fi
	fi
fi
