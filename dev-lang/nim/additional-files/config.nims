import strutils

const
  NimblePkgDirs = staticExec "findpaths B_FIND_PATH_DATA_DIRECTORY nimble/pkgs"

for d in NimblePkgDirs.splitLines:
  switch "NimblePath", d
