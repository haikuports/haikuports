#!/bin/sh

SYSTEM_SETTINGS_DIR="`finddir B_SYSTEM_SETTINGS_DIRECTORY`"

MAN_CONFIG="$SYSTEM_SETTINGS_DIR/man.conf"

if [ -f "$MAN_CONFIG" ] && grep -q '/packages/man-' "$MAN_CONFIG"; then
	sed -i -e "s|/packages/man-[-0-9g\.]\{3,\}/cmd.\+/bin/|/bin/|g" \
		$MAN_CONFIG
fi

true
