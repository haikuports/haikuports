#!/bin/bash

systembin=$(finddir B_SYSTEM_BIN_DIRECTORY)
wad="$(finddir B_SYSTEM_DATA_DIRECTORY)/hacx/HACX.WAD"
wadname="Hacx: Twitch 'n Kill"

if [ -e $systembin/chocolate-doom ]; then
	port1="chocolate-doom"
	port1name="Chocolate Doom"
	echo "Chocolate Doom detected"
fi

if [ -e $systembin/gzdoom ]; then
	if [ "$port1" = "" ]; then
		port1="gzdoom"
		port1name="GZDoom"
	elif [ "$port2" = "" ]; then
		port2="gzdoom"
		port2name="GZDoom"
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
elif [ "$port2" = "" ]; then
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
