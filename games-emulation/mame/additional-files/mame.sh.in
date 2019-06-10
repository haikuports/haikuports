#!/bin/bash
mame=$(findpaths -r 'cmd:mame' B_FIND_PATH_BIN_DIRECTORY mame)
userSettingsDir=$(finddir B_USER_SETTINGS_DIRECTORY)

print() {
  if [ -t 1 ]; then
    echo "$1"
  else
    alert --info "$1"
  fi
}

gen_mame_dirs() {
  echo $userSettingsDir/mame/$1';'$(findpaths -c ';' B_FIND_PATH_LIB_DIRECTORY mame/"$1")
}

mame_first_run() {
  print "Creating an ini file for MAME at $userSettingsDir/mame/mame.ini
Modify this file for permanent changes to your MAME
options and paths before running MAME again."

  mkdir -p "$userSettingsDir/mame" || exit
  cd -- "$userSettingsDir/mame" || exit

  if [ -e mame.ini ]; then
    mv mame.ini mameini.bak || exit
    print "Your old ini file has been renamed to mameini.bak"
  fi

  # Note: the single quotes here are not a mistake; MAME will save these
  # strings verbatim into its configuration file, and expand the variables when
  # it is run in future.
  "$mame" \
    -artpath "$(gen_mame_dirs artwork)" \
    -bgfx_path "$(gen_mame_dirs bgfx)" \
    -ctrlrpath "$(gen_mame_dirs ctrlr)" \
    -hashpath "$(gen_mame_dirs hash)" \
    -languagepath "$(gen_mame_dirs language)" \
    -pluginspath "$(gen_mame_dirs plugins)" \
    -inipath "$(gen_mame_dirs ini)" \
    -rompath "$(gen_mame_dirs roms)" \
    -samplepath "$(gen_mame_dirs samples)" \
    -cfg_directory "$(gen_mame_dirs cfg)" \
    -comment_directory "$(gen_mame_dirs comments)" \
    -diff_directory "$(gen_mame_dirs diff)" \
    -input_directory "$(gen_mame_dirs inp)" \
    -nvram_directory "$(gen_mame_dirs nvram)" \
    -snapshot_directory "$(gen_mame_dirs snap)" \
    -state_directory "$(gen_mame_dirs sta)" \
    -video opengl \
    -createconfig
}

if [ "$1" = "--newini" ]; then
  mame_first_run
  exit
elif ! [ -e "$userSettingsDir/mame" ]; then
  echo "Running MAME for the first time..."

  mkdir -- "$userSettingsDir/mame"
  (
    cd -- "$userSettingsDir/mame" || exit
    mkdir artwork bgfx cfg comments ctrlr diff hash ini inp language nvram samples snap sta roms

    mame_first_run
  ) || exit
fi

exec "$mame" -inipath "$userSettingsDir/mame" -cfg_directory "$userSettingsDir/mame/cfg" "$@"
