#!/bin/sh
dataDir=`finddir B_SYSTEM_DATA_DIRECTORY`/firmware/amd-ucode
targetDir=`finddir B_SYSTEM_NONPACKAGED_DATA_DIRECTORY`/firmware/amd-ucode
mkdir -p $targetDir
cp -p $dataDir/* $targetDir
true
