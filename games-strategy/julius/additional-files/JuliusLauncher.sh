#!/bin/sh

about="Julius is an open source re-implementation of Caesar III.

The aim of this project is to create an open-source version of Caesar 3, \
with the same logic as the original, but with some UI enhancements, that \
is able to be played on multiple platforms. The same logic means that the\
 saved games are 100% compatible, and any gameplay bugs present in the or\
 iginal Caesar 3 game will also be present in Julius.

Julius requires the original assets (graphics, sounds, etc) from Caesar 3\
 to run.

"

configFile="/boot/home/config/settings/julius.ini"
testFile="c3.inf"

dataFolder=$(cat "$configFile") 
scriptFile=$(realpath "$0")
workFolder=$(dirname "$scriptFile")

while true
do
	if [[ "$dataFolder" == "" ]]; then
		idx=`alert --empty "$about Data folder: not selected" \
			"Select game data folder" "Exit"`
	else
		if [ -f "$dataFolder/$testFile" ]; then
			valid="[OK]"
		else
			valid="[ERROR]"
		fi
		idx=`alert --empty "$about Data folder: $dataFolder $valid" \
			"Select game data folder" "Exit" "Play game"`
	fi

	if [[ "$idx" == "Select game data folder" ]]; then		
		selected=`filepanel -l -k d --single -t "Select game data folder"`
		if [ -d $selected ]; then
			dataFolder="$selected"
			echo "$dataFolder" > "$configFile"
			continue
		else
			dataFolder=""
		fi
		if [ -f $selected ]; then
			dataFolder=`dirname "$selected"`
			echo "$dataFolder" > "$configFile"
			continue
		else
			dataFolder=""
		fi
	fi

	if [[ "$idx" == "Play game" ]]; then
		if [ -f "$dataFolder/$testFile" ]; then
			$workFolder/Julius "$dataFolder" &
		else
			alert "Game files not found!"
			continue
		fi
		break
	fi

	if [[ "$idx" == "Exit" ]]; then
		break
	fi
done
