#!/bin/bash

missing_data () {
    if [ $TERM == "dumb" ]; then
        if [ "$(alert --warning "Missing file or directory: $1. Please copy original 'Flashback: The Quest For Identity' \
files and directories to $DATA_PATH." "Open data folder" "Cancel")" == "Open data folder" ]; then
            open $DATA_PATH
        fi
    else
        echo "Missing file or directory: $1. Please copy original 'Flashback: The Quest For Identity' files and directories to $DATA_PATH."
    fi
    exit 1
}

REQ_FILES=('cini.ovl' 'game_e.ovl' 'game_f.ovl' 'game_g.ovl' 'game_i.ovl'
 'game_s.ovl')
REQ_DIRS=('data')
DATA_PATH=`findpaths -e B_FIND_PATH_DATA_DIRECTORY flashback | head -n 1`
SAVE_PATH=`/bin/finddir B_USER_NONPACKAGED_DATA_DIRECTORY`/flashback/save

if [ -z $DATA_PATH ]; then
	DATA_PATH=`/bin/finddir B_USER_NONPACKAGED_DATA_DIRECTORY`/flashback
	mkdir -p $DATA_PATH # create data directory if it does not exist
fi

mkdir -p $SAVE_PATH # create save directory if it does not exist

# Check if required dirs are present
for dir in ${REQ_DIRS[@]}; do
    if [ ! -d $DATA_PATH/$dir ]; then
	missing_data $dir
    fi
done


# Check if required files are present
for file in ${REQ_FILES[@]}; do
    if [ ! -f $DATA_PATH/$file ]; then
        missing_data $file
    fi
done

# all files are present, launch the game
"/system/apps/Flashback" --datapath=$DATA_PATH --savepath=$SAVE_PATH $@ &
