#!/bin/sh
APPDIR="$(dirname -- "$(readlink -f -- "${0}")" )"
cd "$APPDIR"
LD_PRELOAD=$APPDIR/bin/lib/libfakelocaltime.so $APPDIR/bin/OrcaSlicer &
