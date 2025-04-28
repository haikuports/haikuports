#!/bin/bash

# Global variables
OLD_DATA_PATH=`finddir B_USER_SETTINGS_DIRECTORY`/diasurgical/devilution
DATA_PATH=`finddir B_USER_SETTINGS_DIRECTORY`/devilutionx
FILE=$DATA_PATH/diabdat.mpq
DEMOFILE=$DATA_PATH/spawn.mpq
SHAREFILE="$(finddir B_SYSTEM_APPS_DIRECTORY)/devilutionx/spawn.mpq"

# Migration if needed
if [ -e $OLD_DATA_PATH ] && [ ! -e $DATA_PATH ]; then
	mkdir -p $DATA_PATH
	mv -t $DATA_PATH $OLD_DATA_PATH/*
	rm -rf `finddir B_USER_SETTINGS_DIRECTORY`/diasurgical
fi

# Check for Shareware package
if [ ! -e $SHAREFILE ]; then
	SHAREFILE="$(finddir B_USER_APPS_DIRECTORY)/devilutionx/spawn.mpq"
fi

# DevilutionX has issues creating the path on its own
if [ ! -e $DATA_PATH ]; then
	mkdir -p $DATA_PATH
fi

# If the file exists...
if [ -f $FILE ] || [ -f $DEMOFILE ] || [ -f $SHAREFILE ]; then
	# ...then start the program
	DevilutionX $@
else
	# but if it doesn't exist drop a warning
	if [ "$(alert --warning "Please copy Diablo's \"diabdat.mpq\" file or the demo's \"spawn.mpq\" to the Data Folder and rename it to lower-case." "Open Data Folder" "Cancel")" == "Open Data Folder" ]; then
		# then let's open the data Dir
		open $DATA_PATH
	fi
fi
