#!/bin/sh

# for our pid file
install -d -m 755 -o 0 -g 0 `finddir B_SYSTEM_VAR_DIRECTORY`/run

# create our spool dirs
spoolDir=`finddir B_SYSTEM_SPOOL_DIRECTORY`
install -d $spoolDir/cron $spoolDir/anacron
