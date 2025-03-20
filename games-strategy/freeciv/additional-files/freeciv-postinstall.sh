#!/bin/bash

SETTINGS_PATH=$(finddir B_USER_SETTINGS_DIRECTORY)/freeciv
DATA_PATH=$(finddir B_USER_SETTINGS_DIRECTORY)/freeciv/data
SAVE_PATH=$(finddir B_USER_SETTINGS_DIRECTORY)/freeciv/saves
SCENARIO_PATH=$(finddir B_USER_SETTINGS_DIRECTORY)/freeciv/scenarios

if [ ! -e $SETTINGS_PATH ]; then
	mkdir -p $SETTINGS_PATH
fi
if [ ! -e $DATA_PATH ]; then
	mkdir -p $DATA_PATH
fi

if [ ! -e $SAVE_PATH ]; then
	mkdir -p $SAVE_PATH
fi

if [ ! -e $SCENARIO_PATH ]; then
	mkdir -p $SCENARIO_PATH
fi
