#!/bin/sh
APPDIR="$(dirname -- "$(readlink -f -- "${0}")" )"
cd "$APPDIR"
export XDG_RUNTIME_DIR=/var/shared_memory
LD_PRELOAD=$APPDIR/bin/lib/libfakelocaltime.so $APPDIR/bin/OrcaSlicer &
