#!/bin/sh
dataDir=`finddir B_SYSTEM_DATA_DIRECTORY`/firmware/intel-ucode
targetDir=`finddir B_SYSTEM_NONPACKAGED_DATA_DIRECTORY`/firmware/intel-ucode
mkdir -p $targetDir
cpuinfo=$(sysinfo -cpu | grep -oE 'family [[:digit:]]+, model [[:digit:]]+, stepping [[:digit:]]+' | uniq | sed -e 's/[^0-9]\+/ /g' -e 's/^ //')
microcodeFile=$(printf '%02x-%02x-%02x\n' $cpuinfo)
cp -p $dataDir/$microcodeFile $targetDir
true
