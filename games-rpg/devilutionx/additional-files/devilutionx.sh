#!/bin/bash

# Global variables
PROGRAM_NAME="diasurgical/devilution"
DATA_PATH=`/bin/finddir B_USER_SETTINGS_DIRECTORY`/$PROGRAM_NAME
FILE=$DATA_PATH/diabdat.mpq

# If the file exists...
if [ -f $FILE ];
then
   # ...then start the program
   `/bin/finddir B_SYSTEM_APPS_DIRECTORY`/DevilutionX/devilutionx
else

# but if it isn't exist drop a warning
if [ "$(alert --warning "Please, copy your original Diadblo 1 \"diabdat.mpq\" file to the Data Folder and rename it to lower-case." "Open Data Folder" "Cancel")" == "Open Data Folder" ]; then

# then let's create the data Dir and open it
mkdir -p $DATA_PATH
open $DATA_PATH
fi
fi
