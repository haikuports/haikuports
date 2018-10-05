import strutils

const
  nimblePkgDirs = staticExec "findpaths B_FIND_PATH_DATA_DIRECTORY nimble/pkgs"

when defined nimbabel:
  for d in nimblePkgDirs.splitLines:
    switch "NimblePath", d
