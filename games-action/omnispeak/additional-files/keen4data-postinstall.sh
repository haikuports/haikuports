#!/bin/bash

nonpackdatadir=$(finddir B_USER_NONPACKAGED_DATA_DIRECTORY)/omnispeak
datadir=$(finddir B_SYSTEM_DATA_DIRECTORY)/omnispeak

if [ ! -e $nonpackdatadir ]; then
	mkdir -p $nonpackdatadir
fi

ln -s -t $nonpackdatadir $datadir/keen4data/* $datadir/keen4/*
