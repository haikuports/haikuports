#!/bin/sh

_progress () {
	notify --type progress --group ssh-keygen \
		--icon /boot/system/kernel_x86 \
		--messageID $0_$$ \
		--title "Generating ssh keys..." \
		--progress "$1" "$2" >/dev/null
}

# generate SSH host keys

SETTINGSSSHDIR=`finddir B_SYSTEM_SETTINGS_DIRECTORY`/ssh
mkdir -p ${SETTINGSSSHDIR}

hostKeyDir=${SETTINGSSSHDIR}


if [ ! -f "$hostKeyDir/ssh_host_key" ] ; then
	_progress 0.2 "rsa1"
	ssh-keygen -t rsa1 -f "$hostKeyDir/ssh_host_key" -N ""
fi

if [ ! -f "$hostKeyDir/ssh_host_dsa_key" ] ; then
	_progress 0.4 "dsa"
	ssh-keygen -t dsa -f "$hostKeyDir/ssh_host_dsa_key" -N ""
fi

if [ ! -f "$hostKeyDir/ssh_host_ecdsa_key" ] ; then
	_progress 0.6 "ecdsa"
	ssh-keygen -t ecdsa -f "$hostKeyDir/ssh_host_ecdsa_key" -N ""
fi

if [ ! -f "$hostKeyDir/ssh_host_rsa_key" ] ; then
	_progress 0.8 "rsa"
	ssh-keygen -t rsa -f "$hostKeyDir/ssh_host_rsa_key" -N ""
	_progress 1.0 ""
fi
