#!/bin/sh

_progress () {
	notify --type progress --app ssh-keygen \
		--icon /boot/system/kernel_x86 \
		--messageID $0_$$ \
		--title "Generating ssh keys..." \
		--progress "$1" "$2" >/dev/null
}

# generate SSH host keys

SETTINGSSSHDIR=`finddir B_COMMON_SETTINGS_DIRECTORY`/ssh
mkdir -p ${SETTINGSSSHDIR}

hostKeyDir=${SETTINGSSSHDIR}

_progress 0.0 "rsa1"
if [ ! -f "$hostKeyDir/ssh_host_key" ] ; then
	ssh-keygen -t rsa1 -f "$hostKeyDir/ssh_host_key" -N ""
fi

_progress 0.3 "dsa"
if [ ! -f "$hostKeyDir/ssh_host_dsa_key" ] ; then
	ssh-keygen -t dsa -f "$hostKeyDir/ssh_host_dsa_key" -N ""
fi

_progress 0.6 "rsa"
if [ ! -f "$hostKeyDir/ssh_host_rsa_key" ] ; then
	ssh-keygen -t rsa -f "$hostKeyDir/ssh_host_rsa_key" -N ""
fi

_progress 1.0 ""
