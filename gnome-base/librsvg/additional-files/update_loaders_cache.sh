#!/bin/sh
SETTINGS_DIR=`finddir B_SYSTEM_SETTINGS_DIRECTORY`/gdk-pixbuf-2.0
mkdir -p $SETTINGS_DIR
gdk-pixbuf-query-loaders --update-cache
