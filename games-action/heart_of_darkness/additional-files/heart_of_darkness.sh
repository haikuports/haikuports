#!/bin/bash

REQ_FILES=('Dark_hod.lvl' 'Dark_hod.mst' 'Dark_hod.sss' 'Fort_hod.lvl' 
 'Fort_hod.mst' 'Fort_hod.sss' 'Isld_hod.lvl' 'Isld_hod.mst' 
 'Isld_hod.sss' 'Lar1_hod.lvl' 'Lar1_hod.mst' 'Lar1_hod.sss' 'Lar2_hod.lvl' 
 'Lar2_hod.mst' 'Lar2_hod.sss' 'Lava_hod.lvl' 'Lava_hod.mst' 'Lava_hod.sss' 
 'Pwr1_hod.lvl' 'Pwr1_hod.mst' 'Pwr1_hod.sss' 'Pwr2_hod.lvl' 'Pwr2_hod.mst' 
 'Pwr2_hod.sss' 'Rock_hod.lvl' 'Rock_hod.mst' 'Rock_hod.sss' 'paf/HOD.PAF'
 'setup/Setup.dat')
DATA_PATH=`findpaths -e B_FIND_PATH_DATA_DIRECTORY heart-of-darkness | head -n 1`
SAVE_PATH=`/bin/finddir B_USER_NONPACKAGED_DATA_DIRECTORY`/heart-of-darkness/save

if [ -z $DATA_PATH ]; then
	DATA_PATH=`/bin/finddir B_USER_NONPACKAGED_DATA_DIRECTORY`/heart-of-darkness
	mkdir -p $DATA_PATH # create data directory if it does not exist
fi

mkdir -p $SAVE_PATH # create save directory if it does not exist

# Check if all files are present
for file in ${REQ_FILES[@]}; do
    if [ ! -f $DATA_PATH/$file ]; then
        if [ $TERM == "dumb" ]; then
            if [ "$(alert --warning "Missing file: $file. Please copy original 'Heart of Darkness' \
files to $DATA_PATH." "Open data folder" "Cancel")" == "Open data folder" ]; then
                open $DATA_PATH
            fi
        else
            echo "Missing file: $file. Please copy original 'Heart of Darkness' files to $DATA_PATH."
        fi
        exit 1
    fi
done

# all files are present, launch the game
"/system/apps/Heart of Darkness" --datapath=$DATA_PATH --savepath=$SAVE_PATH $@ &
