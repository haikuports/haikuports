#!/bin/bash

wad1="$(finddir B_SYSTEM_DATA_DIRECTORY)/doomdata/freedoom1.wad"
wad2="$(finddir B_SYSTEM_DATA_DIRECTORY)/doomdata/freedoom2.wad"


if [ ! -e $wad1 ]; then
	wad1="$(finddir B_USER_DATA_DIRECTORY)/doomdata/freedoom1.wad"
	wad2="$(finddir B_USER_DATA_DIRECTORY)/doomdata/freedoom2.wad"
	if [ ! -e $wad1 ]; then
		alert --stop "Game data not found!"
		exit 1
	fi
fi

if [ "$1" = "1" ]; then
	wad=$wad1
	wadname="Freedoom: Phase 1"
	echo "$wadname selected"
elif [ "$1" = "2" ]; then
	wad=$wad2
	wadname="Freedoom: Phase 2"
	echo "$wadname selected"
fi

# Can only have 3 buttons on these kinds of alerts AFAICT

# Slot 1 is reserved for Chocolate Doom
if [ $(command -v chocolate-doom) ]; then
	port1="chocolate-doom"
	port1name="Chocolate Doom"
	echo "Chocolate Doom detected"
fi

# Slot 2 is for PrBoom+
if [ $(command -v prboom-plus) ]; then
	if [ "$port1" = "" ]; then
		port1="prboom-plus"
		port1name="PrBoom+"
	elif [ "$port2" = "" ]; then
		port2="prboom-plus"
		port2name="PrBoom+"
	fi
	echo "PrBoom+ detected"
fi

# Slot 3 is UZDoom > GZDoom 4 > LZDoom > GZDoom 3
# But can still populate earlier slots
if [ $(command -v UZDoom) ]; then
	if [ "$port1" = "" ]; then
		port1="UZDoom"
		port1name=$port1
	elif [ "$port2" = "" ]; then
		port2="UZDoom"
		port2name=$port2
	elif [ "$port3" = "" ]; then
		port3="UZDoom"
		port3name=$port3
	fi
	echo "UZDoom detected"
elif [ $(command -v GZDoom) ]; then
	if [ "$port1" = "" ]; then
		port1="GZDoom"
		port1name=$port1
	elif [ "$port2" = "" ]; then
		port2="GZDoom"
		port2name=$port2
	elif [ "$port3" = "" ]; then
		port3="GZDoom"
		port3name=$port3
	fi
	echo "GZDoom detected"
fi

if [ $(command -v LZDoom) ]; then
	if [ "$port1" = "" ]; then
		port1="LZDoom"
		port1name=$port1
	elif [ "$port2" = "" ]; then
		port2="LZDoom"
		port2name=$port2
	elif [ "$port3" = "" ]; then
		port3="LZDoom"
		port3name=$port3
	fi
	echo "LZDoom detected"
fi

if [ -e $(finddir B_SYSTEM_APPS_DIRECTORY)/GZDoom/GZDoom ]; then
	if [ "$port1" = "" ]; then
		port1="$(finddir B_SYSTEM_APPS_DIRECTORY)/GZDoom/GZDoom"
		port1name="GZDoom (Legacy)"
	elif [ "$port2" = "" ]; then
		port2="$(finddir B_SYSTEM_APPS_DIRECTORY)/GZDoom/GZDoom"
		port2name="GZDoom (Legacy)"
	elif [ "$port3" = "" ]; then
		port3="$(finddir B_SYSTEM_APPS_DIRECTORY)/GZDoom/GZDoom"
		port3name="GZDoom (Legacy)"
	fi
	echo "GZDoom (Legacy) detected"
elif [ -e $(finddir B_USER_APPS_DIRECTORY)/GZDoom/GZDoom ]; then
	if [ "$port1" = "" ]; then
		port1="$(finddir B_USER_APPS_DIRECTORY)/GZDoom/GZDoom"
		port1name="GZDoom (Legacy)"
	elif [ "$port2" = "" ]; then
		port2="$(finddir B_USER_APPS_DIRECTORY)/GZDoom/GZDoom"
		port2name="GZDoom (Legacy)"
	elif [ "$port3" = "" ]; then
		port3="$(finddir B_USER_APPS_DIRECTORY)/GZDoom/GZDoom"
		port3name="GZDoom (Legacy)"
	fi
	echo "GZDoom (Legacy) detected"
fi

if [ "$port1" = "" ]; then
	alert --stop "No Doom source port detected!"
else
	if [ "$wadname" = "" ]; then
		askwad=$(alert --idea "Choose between Freedoom Phase 1 and Phase 2" "Phase 1" "Phase 2")
		if [ "$askwad" = "Phase 1" ]; then
			wad=$wad1
		elif [ "$askwad" = "Phase 2" ]; then
			wad=$wad2
		fi
		wadname="Freedoom: $askwad"
		echo "$wadname selected"
	fi
	if [ "$port2" = "" ]; then
		echo "Only one port detected, running it by default"
		$port1 -iwad $wad $@
	else
		askport="Multiple Doom source ports detected. Choose one to use with '$wadname'"
		if [ "$port3" = "" ]; then
			button=$(alert --idea "$askport" "$port1name" "$port2name")
		else
			button=$(alert --idea "$askport" "$port1name" "$port2name" "$port3name")
		fi
		echo "$button selected"
		if [ "$button" = "$port1name" ]; then
			$port1 -iwad $wad $@
		elif [ "$button" = "$port2name" ]; then
			$port2 -iwad $wad $@
		elif [ "$button" = "$port3name" ]; then
			$port3 -iwad $wad $@
		fi
	fi
fi
