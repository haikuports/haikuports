#!/bin/sh

_progress () {
	notify --type progress --group ssh-keygen \
		--icon /system/kernel_`uname -p` \
		--messageID $0_$$ \
		--title "Generating ssh keys..." \
		--progress "$1" "$2" >/dev/null
}

# generate SSH host keys

SETTINGSSSHDIR=`finddir B_SYSTEM_SETTINGS_DIRECTORY`/ssh
mkdir -p ${SETTINGSSSHDIR}

hostKeyDir=${SETTINGSSSHDIR}


if [ ! -f "$hostKeyDir/ssh_host_ecdsa_key" ] ; then
	_progress 0.2 "ecdsa"
	ssh-keygen -t ecdsa -f "$hostKeyDir/ssh_host_ecdsa_key" -N ""
fi

if [ ! -f "$hostKeyDir/ssh_host_rsa_key" ] ; then
	_progress 0.5 "rsa"
	ssh-keygen -t rsa -f "$hostKeyDir/ssh_host_rsa_key" -N ""
fi

if [ ! -f "$hostKeyDir/ssh_host_ed25519_key" ] ; then
	_progress 0.8 "ed25519"
	ssh-keygen -t ed25519 -f "$hostKeyDir/ssh_host_ed25519_key" -N ""
fi

# generate what's eventually missing
ssh-keygen -A
_progress 1.0 ""
