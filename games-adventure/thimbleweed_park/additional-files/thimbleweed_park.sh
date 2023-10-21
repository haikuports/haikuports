#!/bin/bash

missing_data () {
    if [ $TERM == "dumb" ]; then
        if [ "$(alert --warning "Missing file: $1. Please copy original 'Thimbleweed Park' \
files to $DATA_PATH." "Open data folder" "Cancel")" == "Open data folder" ]; then
            open $DATA_PATH
        fi
    else
        echo "Missing file: $1. Please copy original 'Thimbleweed Park' files to $DATA_PATH."
    fi
    exit 1
}

REQ_FILES=('ThimbleweedPark.ggpack1' 'ThimbleweedPark.ggpack2')
DATA_PATH=`findpaths -e B_FIND_PATH_DATA_DIRECTORY thimbleweed-park | head -n 1`
SAVE_PATH=`/bin/finddir B_USER_NONPACKAGED_DATA_DIRECTORY`/thimbleweed-park/save

if [ -z $DATA_PATH ]; then
	DATA_PATH=`/bin/finddir B_USER_NONPACKAGED_DATA_DIRECTORY`/thimbleweed-park
	mkdir -p $DATA_PATH # create data directory if it does not exist
fi

mkdir -p $SAVE_PATH # create save directory if it does not exist

# Check if required files are present
for file in ${REQ_FILES[@]}; do
    if [ ! -f $DATA_PATH/$file ]; then
        missing_data $file
    fi
done

# all files are present, launch the game
cd DATA_PATH
"/system/bin/engge2" $@ &