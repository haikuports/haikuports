#!/bin/bash

REQ_FILES=('BANK01' 'BANK02' 'BANK03' 'BANK04' 'BANK05' 'BANK06' 'BANK07'
 'BANK08' 'BANK09' 'BANK0A' 'BANK0B' 'BANK0C' 'BANK0D' 'MEMLIST.BIN')
DATA_PATH=`findpaths -e B_FIND_PATH_DATA_DIRECTORY another_world | head -n 1`
SAVE_PATH=`/bin/finddir B_USER_NONPACKAGED_DATA_DIRECTORY`/another_world/save

if [ -z $DATA_PATH ];
then
	DATA_PATH=`/bin/finddir B_USER_NONPACKAGED_DATA_DIRECTORY`/another_world
	mkdir -p $DATA_PATH # create data directory if it does not exist
fi

mkdir -p $SAVE_PATH # create save directory if it does not exist

# Check if all files are present
for file in ${REQ_FILES[@]};
do
    if [ ! -f $DATA_PATH/$file ];
    then
        if [ $TERM == "dumb" ];
        then
            if [ "$(alert --warning "Missing file: $file. Please copy original 'Another World' files (DOS version) to $DATA_PATH (BANK* and MEMLIST.BIN)." "Open data folder" "Cancel")" == "Open data folder" ];
            then
                open $DATA_PATH
            fi
        else
            echo "Missing file: $file. Please copy original 'Another World' files (DOS version) to $DATA_PATH (BANK* and MEMLIST.BIN)."
        fi
        exit
    fi
done

# all files are present, launch the game
neo-raw --datapath=$DATA_PATH --savepath=$SAVE_PATH $@ &
