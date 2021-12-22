#!/bin/sh

installDir="$(finddir B_USER_NONPACKAGED_DIRECTORY)/bin/"
binaryDir="$(finddir B_SYSTEM_BIN_DIRECTORY)"
mkdir -p $installDir

cp -f "$binaryDir/fpcupdeluxe" "$installDir/FPCUPdeluxe"
