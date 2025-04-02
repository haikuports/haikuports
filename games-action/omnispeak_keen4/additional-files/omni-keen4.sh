#!/bin/bash

omnibin=$(finddir B_SYSTEM_BIN_DIRECTORY)/omnispeak
k4data=$(finddir B_SYSTEM_DATA_DIRECTORY)/omnispeak/keen4

$omnibin /GAMEPATH $k4data
