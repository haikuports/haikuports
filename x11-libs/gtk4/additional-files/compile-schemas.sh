#!/bin/sh
SYSTEM_DATA_DIR="`finddir B_SYSTEM_DATA_DIRECTORY`"
NONPACKAGED_DATA_DIR="`finddir B_SYSTEM_NONPACKAGED_DATA_DIRECTORY`"

mkdir -p $NONPACKAGED_DATA_DIR/glib-2.0/schemas
cp -nrf $SYSTEM_DATA_DIR/glib-2.0/schemas/* $NONPACKAGED_DATA_DIR/glib-2.0/schemas

glib-compile-schemas $NONPACKAGED_DATA_DIR/glib-2.0/schemas
