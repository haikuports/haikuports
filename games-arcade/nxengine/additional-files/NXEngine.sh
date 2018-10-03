#!/bin/bash
if [[ `locale -l` == ru* ]] ;
then
    EXE="`finddir B_SYSTEM_APPS_DIRECTORY`/NXEngine/RUS/nx-rus"
else
    EXE="`finddir B_SYSTEM_APPS_DIRECTORY`/NXEngine/ENG/nx"
fi
$EXE $@
