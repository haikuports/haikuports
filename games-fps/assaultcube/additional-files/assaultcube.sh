#!/bin/bash

acbin=$(finddir B_SYSTEM_APPS_DIRECTORY)/AssaultCube/ac_client

if [ ! -e $acbin ]; then
	acbin=$(finddir B_USER_APPS_DIRECTORY)/AssaultCube/ac_client
fi

$acbin --init --loadmap=ac_ingress $@
