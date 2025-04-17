#!/bin/bash

# Global variables
OLD_PROG_NAME="diasurgical/devilution"
PROGRAM_NAME="devilutionx"
OLD_DATA_PATH=`finddir B_USER_SETTINGS_DIRECTORY`/$OLD_PROG_NAME
DATA_PATH=`finddir B_USER_SETTINGS_DIRECTORY`/$PROGRAM_NAME
FILE=$DATA_PATH/diabdat.mpq
DEMOFILE=$DATA_PATH/spawn.mpq

# Migration if needed
if [ -e $OLD_DATA_PATH ] && [ ! -e $DATA_PATH ]; then
mkdir -p $DATA_PATH
mv -t $DATA_PATH $OLD_DATA_PATH/*
rm -rf `finddir B_USER_SETTINGS_DIRECTORY`/diasurgical
fi

# If the file exists...
if [ -f $FILE ] || [ -f $DEMOFILE ]; then
# ...then start the program
DevilutionX
else
# but if it isn't exist drop a warning
if [ "$(alert --warning "Please, copy Diablo's \"diabdat.mpq\" file or the demo's \"spawn.mpq\" to the Data Folder and rename it to lower-case." "Open Data Folder" "Cancel")" == "Open Data Folder" ]; then
# then let's create the data Dir and open it
mkdir -p $DATA_PATH
open $DATA_PATH
fi
fi
