#!/bin/bash
# Make the writeable BeShare files directory, which is now needed
# since the application folder is read only due to the packaging
# system.  AGMS20150113

mkdir --parents "`finddir B_USER_DIRECTORY`/BeShare/downloads"
mkdir --parents "`finddir B_USER_DIRECTORY`/BeShare/logs"
mkdir --parents "`finddir B_USER_DIRECTORY`/BeShare/shared"
notify --type information --group "BeShare Installer" --title "BeShare Folders" --timeout 45 "Folders for your shared files, downloads and logs have been created in `finddir B_USER_DIRECTORY`/BeShare/  Change them to symbolic links if you want to move them elsewhere."
notify --type information --group "BeShare Installer" --title "BeShare Documentation" --timeout 30 "Extra documentation has been installed in a documentation/packages/BeShare  folder somewhere.  Just do a desktop search for BeShare."
