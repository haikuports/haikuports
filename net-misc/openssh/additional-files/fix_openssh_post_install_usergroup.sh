#!/bin/sh
# Create the users and groups needed by sshd.  They are part of the package
# metadata, but that currently (Beta1, Beta2) doesn't work for packages in a
# newly installed system (the installation actions aren't run since the files
# are just copied to the new system).  So until running installation stuff
# on first boot is fixed (Beta3?), redundantly create the user and group in
# the post-install script, which is run on the first boot by launch_daemon.
# See https://dev.haiku-os.org/ticket/14382

# Remove the user created by the installer (if it did install), has the wrong group.
userdel "sshd"

groupadd "sshd"
useradd -n "sshd user" -d "SubstUserHomeDirHere" -s "/bin/true" -g "sshd" "sshd"
