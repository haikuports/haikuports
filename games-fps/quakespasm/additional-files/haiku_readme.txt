
Installing game data files for QuakeSpasm on Haiku
===============================================================

QuakeSpasm for Haiku searches for game data at the system directory specified
by the symbolic constant `B_USER_NONPACKAGED_DATA_DIRECTORY` + `/QuakeSpasm/`.

On a normal system install, this would be located at:
`/boot/home/config/non-packaged/data/QuakeSpasm/`

Screenshots and configuration files are also saved here.

To install the shareware or registered versions of Quake, place the files
pak0.pak and pak1.pak into the following directory:
`/boot/home/config/non-packaged/data/QuakeSpasm/id1/`

Any mods for Quake should be installed accordingly, with the folder name "id1"
being replaced with the name of the mod (no spaces).
