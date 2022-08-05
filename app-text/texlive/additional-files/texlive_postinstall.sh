#!/bin/bash

processList=$(ps)
processCount=$(grep texlive_update.sh <<< "$processList" | wc -l)
if [ $processCount -eq 0 ]; then # if no texlive_update is running yet, run it
	/boot/system/bin/texlive_update.sh &
fi
