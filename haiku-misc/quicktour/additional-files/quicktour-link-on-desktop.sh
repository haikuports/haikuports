#!/bin/sh

# Script to create a symlink of the Haiku Quick Tour
# start page on the Desktop

startPage="01-start.html"
desktopDir="$(finddir B_DESKTOP_DIRECTORY)"
source="$(findpaths -e B_FIND_PATH_DOCUMENTATION_DIRECTORY quicktour/en/$startPage)"

if [ -e "$source" ]; then
	ln -sf "$source" "$desktopDir/QuickTour"
else
	exit 1 # couldn't find Quick Tour
fi
