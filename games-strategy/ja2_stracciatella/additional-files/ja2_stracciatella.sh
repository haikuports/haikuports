#!/bin/bash

# Global variables
PROGRAM_NAME=ja2
DATA_PATH=`/bin/finddir B_USER_NONPACKAGED_DATA_DIRECTORY`/$PROGRAM_NAME
FILE=$DATA_PATH/data/binarydata/ja2bin.dat
CONFIG_FILE_PATH=`/bin/finddir B_USER_SETTINGS_DIRECTORY`/$PROGRAM_NAME
CONFIG_FILE=$CONFIG_FILE_PATH/ja2.json

# If the file exists...
if [ -f $FILE ];
then
   # ...then start the program
   `/bin/finddir B_SYSTEM_APPS_DIRECTORY`/JA2/bin/ja2 -datadir $DATA_PATH $@
else

# but if it isn't exist drop a warning
if [ "$(alert --warning "Please, copy your original JA2 Files to the Data Folder and rename them to lower-case." "Open Data Folder" "Cancel")" == "Open Data Folder" ]; then

# then let's create the data Dir and open it
mkdir -p $CONFIG_FILE_PATH
echo "{"  >> $CONFIG_FILE
echo "\"data_dir\": \"$DATA_PATH\"" >> $CONFIG_FILE
echo "}"  >> $CONFIG_FILE

mkdir -p $DATA_PATH
open $DATA_PATH
fi
fi
