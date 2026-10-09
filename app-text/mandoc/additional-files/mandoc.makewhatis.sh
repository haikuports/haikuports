#!/bin/sh

if [ -f /bin/makewhatis ]
then
  export MANPATH=`findpaths -c: B_FIND_PATH_DOCUMENTATION_DIRECTORY man`
  /bin/makewhatis -a
fi
