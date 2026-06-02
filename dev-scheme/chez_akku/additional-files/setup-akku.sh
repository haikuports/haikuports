#!/bin/bash

dataDir="$(finddir B_SYSTEM_DATA_DIRECTORY)/akku"
installDataDir="$(finddir B_USER_NONPACKAGED_DATA_DIRECTORY)"

mkdir -p $installDataDir
cp -rf "${dataDir}" "${installDataDir}"

