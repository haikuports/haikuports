#!/bin/bash

systembin=$(finddir B_SYSTEM_BIN_DIRECTORY)
systemapps=$(finddir B_SYSTEM_APPS_DIRECTORY)
waddir="$(finddir B_SYSTEM_DATA_DIRECTORY)/doomdata"

if [ "$1" = "1" ]; then
	wad="$waddir/freedoom1.wad"
	wadname="Freedoom: Phase 1"
	echo "$wadname selected"
elif [ "$1" = "2" ]; then
	wad="$waddir/freedoom2.wad"
	wadname="Freedoom: Phase 2"
	echo "$wadname selected"
fi

if [ -e $systembin/chocolate-doom ]; then
	port1="chocolate-doom"
	port1name="Chocolate Doom"
	echo "Chocolate Doom detected"
fi

if [ -e $systemapps/GZDoom ]; then
	if [ "$port1" = "" ]; then
		port1="GZDoom"
		port1name=$port1
	elif [ "$port2" = "" ]; then
		port2="GZDoom"
		port2name=$port2
	fi
	echo "GZDoom detected"
fi

if [ -e $systembin/prboom-plus ]; then
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
	if [ "$wad" = "" ]; then
		askwad=$(alert --idea "Choose between Freedoom Phase 1 and Phase 2" "Phase 1" "Phase 2")
		if [ "$askwad" = "Phase 1" ]; then
			wad="$waddir/freedoom1.wad"
		elif [ "$askwad" = "Phase 2" ]; then
			wad="$waddir/freedoom2.wad"
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
