#!/bin/bash
if [[ `locale -l` == ru* ]] ;
then
    EXE="`finddir B_SYSTEM_APPS_DIRECTORY`/NXEngine/RUS/Cave Story"
else
    EXE="`finddir B_SYSTEM_APPS_DIRECTORY`/NXEngine/ENG/Cave Story"
fi
"$EXE" $@
