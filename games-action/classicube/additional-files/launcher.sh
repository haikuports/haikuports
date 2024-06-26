#!/bin/sh
APP=`finddir B_APPS_DIRECTORY`/ClassiCube/ClassiCube
SETTINGS_DIR=`finddir B_USER_SETTINGS_DIRECTORY`/ClassiCube
mkdir -p ${SETTINGS_DIR}
$APP -d${SETTINGS_DIR}
