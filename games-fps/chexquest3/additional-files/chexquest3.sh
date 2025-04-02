#!/bin/bash

systemapps=$(finddir B_SYSTEM_APPS_DIRECTORY)
wad="$(finddir B_SYSTEM_DATA_DIRECTORY)/gzdoom/chex3.wad"

$systemapps/GZDoom -iwad $wad $@
