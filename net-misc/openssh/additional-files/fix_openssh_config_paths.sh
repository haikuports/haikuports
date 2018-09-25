#!/bin/sh

SYSTEM_SETTINGS_DIR="`finddir B_SYSTEM_SETTINGS_DIRECTORY`"
USER_SETTINGS_DIR="`finddir B_USER_SETTINGS_DIRECTORY`"
VAR_DIR="`finddir B_SYSTEM_VAR_DIRECTORY`"
LIB_DIR="`finddir B_SYSTEM_LIB_DIRECTORY`"

SSH_CONFIG="$SYSTEM_SETTINGS_DIR/ssh/ssh_config"
SSHD_CONFIG="$SYSTEM_SETTINGS_DIR/ssh/sshd_config"

if [ -f "$SSH_CONFIG" ] && grep -q 'IdentityFile ~/\.ssh/' "$SSH_CONFIG"; then
	sed --in-place=.bak \
		-e "s| ~/\.ssh/| $USER_SETTINGS_DIR/ssh/|" \
		$SYSTEM_SETTINGS_DIR/ssh/ssh_config
fi

if [ -f "$SSHD_CONFIG" ] && grep -q '/packages/openssh-' "$SSHD_CONFIG"; then
	sed --in-place=.bak \
		-e "s|/packages/openssh-[-0-9p\.]\{3,\}/\.settings/ssh/|$SYSTEM_SETTINGS_DIR/ssh/|" \
		-e "s|/packages/openssh-[-0-9p\.]\{3,\}/\.self/var/run/|$VAR_DIR/run/|" \
		-e "s|/packages/openssh-[-0-9p\.]\{3,\}/\.self/lib/openssh/|$LIB_DIR/openssh/|" \
		$SYSTEM_SETTINGS_DIR/ssh/sshd_config
fi

true
