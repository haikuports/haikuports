#!/bin/bash

VAR_PATH=$(finddir B_USER_VAR_DIRECTORY)/wesnothd

if [ ! -e $VAR_PATH ]; then
	mkdir -p $VAR_PATH
fi
