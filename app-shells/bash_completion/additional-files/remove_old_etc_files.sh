#!/bin/sh

# Previous versions (<=2.17) used a different location for "000_bash_completion_compat.bash".

oldFile=`finddir B_SYSTEM_ETC_DIRECTORY`/bash_completion.d/000_bash_completion_compat.bash
newFile=`finddir B_SYSTEM_DATA_DIRECTORY`/bash-completion/startup-core/000_bash_completion_compat.bash

if [ ! -e $oldFile]; then
	# Old file is not present, just exit.
	exit 0
fi

# Remove old file only if it doesn't looks to have been user modified.
# Check by comparing with the newer one, that has two specific lines removed as difference.
if [ $(diff $newFile $oldFile | grep -e "shell-script" -e "filetype=sh" | wc -l) -eq 2 ]; then
	logger "[bash_completion] Note: removing 000_bash_completion_compat.bash from old location (/system/settings/etc/)"
	rm $oldFile
else
	logger "[bash_completion]Warning: leaving $oldFile as is, as it looks to have been user-modified."
	logger "[bash_completion]Warning: (bash_completion >= 2.18 doesn't uses this file from this location anymore."
fi
