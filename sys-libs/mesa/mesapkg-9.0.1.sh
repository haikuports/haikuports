#!/bin/bash
# Mesa-O-Matic
# Copyright 2011-2012, Alexander von Gluck IV
# Released under the terms of the MIT license

# This script creates an optional package containing the
# the headers and binary code needed by the opengl kit
# to link libGL.so

# This script is run against a *COMPILED* Mesa source tree

echo " Welcome to Mesa-O-Matic!"
echo "-=-=-=-=-=-=-=-=-=-=-=-=-="
echo ""

DEBUG=0

#######################################################################
# END CONFIG DATA, Dragons below!
#######################################################################

if [[ $( uname ) != "Haiku" ]]; then
	echo "*************************************"
	echo " I need to be run on a Haiku system!!"
	echo "*************************************"
	exit 1
fi

if [[ -z $1 ]]; then
	echo ""
	echo "Usage: $0 <compiled mesa location>"
	echo ""
	exit 1
fi

MESA_TOP="$1"
GCC_VER=`gcc -v 2>&1 | tail -1 | awk '{print $3}' | cut -d. -f1`
DATESTAMP=`date +"%Y-%m-%d"`

echo "Bundling gcc$GCC_VER build of Mesa 9.0..."

cd $MESA_TOP

#######################################################################
# Create Mesa optional pacakge
ZIP_HEADERS=""
echo "Collecting Mesa headers..."
for i in $(find . -name "*.h")
do
	ZIP_HEADERS="$ZIP_HEADERS $i"
done

echo "Collecting required Mesa libraries..."
rm -rf lib.haiku
mkdir -p lib.haiku
for i in $( find . -name "*.a" ) 
do
	cp $i lib.haiku/
done

if [[ $DEBUG -eq 0 ]]; then
echo "Stripping debug symbols from Mesa libraries..."
find lib.haiku -exec strip --strip-debug {} \; ;
MESADBG=""
else
MESADBG="-dbg"
fi

echo "Creating Mesa OptionalPackage..."
PLATFORM=$( uname -m )
ZIP_FILENAME="/boot/home/mesa-9.0.1${MESADBG}-x86-gcc${GCC_VER}-${DATESTAMP}.zip"
zip -r -9 $ZIP_FILENAME $ZIP_HEADERS ./lib.haiku/*

echo "Great Success! $ZIP_FILENAME created."
