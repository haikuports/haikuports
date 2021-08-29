#!/bin/bash

if [ "$1" == "--wait"]; then
	sleep 5	# wait for all subpackages to be installed before doing anything
fi

mktexlsr
fmtutil-sys --all
#mtxrun --generate
updmap-sys

