#!/bin/bash

DATA_PATH=`/bin/finddir B_USER_NONPACKAGED_DATA_DIRECTORY`/another_world
SAVE_PATH=`/bin/finddir B_USER_NONPACKAGED_DATA_DIRECTORY`/another_world/save

mkdir -p $DATA_PATH # create data directory if it does not exist
mkdir -p $SAVE_PATH # create save directory if it does not exist

# Check if all files are present
if [ ! -f $DATA_PATH/BANK01 ] \
|| [ ! -f $DATA_PATH/BANK02 ] \
|| [ ! -f $DATA_PATH/BANK03 ] \
|| [ ! -f $DATA_PATH/BANK04 ] \
|| [ ! -f $DATA_PATH/BANK05 ] \
|| [ ! -f $DATA_PATH/BANK06 ] \
|| [ ! -f $DATA_PATH/BANK07 ] \
|| [ ! -f $DATA_PATH/BANK08 ] \
|| [ ! -f $DATA_PATH/BANK09 ] \
|| [ ! -f $DATA_PATH/BANK0A ] \
|| [ ! -f $DATA_PATH/BANK0B ] \
|| [ ! -f $DATA_PATH/BANK0C ] \
|| [ ! -f $DATA_PATH/BANK0D ] \
|| [ ! -f $DATA_PATH/MEMLIST.BIN ];
then
    if [ "$(alert --warning "Please copy original Another World files (DOS version) to $DATA_PATH (BANK* and MEMLIST.BIN)." "Open $DATA_PATH" "Cancel")" == "Open $DATA_PATH" ]; then
        open $DATA_PATH
    fi
else # all files are present, launch the game
   `/bin/finddir B_SYSTEM_APPS_DIRECTORY`/AnotherWorld/raw --datapath=$DATA_PATH --savepath=$SAVE_PATH $@
fi