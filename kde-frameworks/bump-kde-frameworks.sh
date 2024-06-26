#/bin/sh
source ~/config/settings/haikuports.conf
cd "$TREE_PATH"/kde-frameworks/

old_version=5.80
new_version=5.86

# bump recipe filenames
echo WARNING: you need to bump ki18n manually
find . -maxdepth 2 -type f -name "*$old_version*.recipe" | grep -v 1 |
while read fname; do git mv $fname ${fname//$old_version/$new_version}; done

# bump patchset filenames
find . -maxdepth 3 -type f -name "*$old_version*.patchset" | grep -v 1 |
while read fname; do git mv $fname ${fname//$old_version/$new_version}; done

# reset revision
sed -i "/^REVISION=/s/=.*/=\"1\"/" */*.recipe

# print SOURCE_URI recipe file name 
find . -maxdepth 2 -name "*$new_version*.recipe" | while read FNAME; do \
portVersion=$new_version.0 ; source $FNAME ; echo $SOURCE_URI $FNAME ;

# replace CHECKSUM_SHA256 with new once
sed -i "s/$CHECKSUM_SHA256/`curl -sL $SOURCE_URI | sha256sum | head -c 64`/" $FNAME ; done




# the recipes should be built in this order

haikuporter -S -j1 --no-source-packages --get-dependencies extra_cmake_modules
haikuporter -S -j1 --no-source-packages --get-dependencies phonon
haikuporter -S -j1 --no-source-packages --get-dependencies karchive
haikuporter -S -j1 --no-source-packages --get-dependencies kcodecs
haikuporter -S -j1 --no-source-packages --get-dependencies kconfig
haikuporter -S -j1 --no-source-packages --get-dependencies kcoreaddons
haikuporter -S -j1 --no-source-packages --get-dependencies kdbusaddons
haikuporter -S -j1 --no-source-packages --get-dependencies kguiaddons
haikuporter -S -j1 --no-source-packages --get-dependencies ki18n
haikuporter -S -j1 --no-source-packages --get-dependencies kitemmodels
haikuporter -S -j1 --no-source-packages --get-dependencies kitemviews
haikuporter -S -j1 --no-source-packages --get-dependencies kwidgetsaddons
haikuporter -S -j1 --no-source-packages --get-dependencies kwindowsystem
haikuporter -S -j1 --no-source-packages --get-dependencies solid
haikuporter -S -j1 --no-source-packages --get-dependencies sonnet
haikuporter -S -j1 --no-source-packages --get-dependencies threadweaver
haikuporter -S -j1 --no-source-packages --get-dependencies kauth
haikuporter -S -j1 --no-source-packages --get-dependencies kcompletion
haikuporter -S -j1 --no-source-packages --get-dependencies kcrash
haikuporter -S -j1 --no-source-packages --get-dependencies kdoctools
haikuporter -S -j1 --no-source-packages --get-dependencies kunitconversion
haikuporter -S -j1 --no-source-packages --get-dependencies kconfigwidgets
haikuporter -S -j1 --no-source-packages --get-dependencies kservice
haikuporter -S -j1 --no-source-packages --get-dependencies kglobalaccel
haikuporter -S -j1 --no-source-packages --get-dependencies kpackage
haikuporter -S -j1 --no-source-packages --get-dependencies kemoticons
haikuporter -S -j1 --no-source-packages --get-dependencies kiconthemes
haikuporter -S -j1 --no-source-packages --get-dependencies kjobwidgets
haikuporter -S -j1 --no-source-packages --get-dependencies knotifications
haikuporter -S -j1 --no-source-packages --get-dependencies ktextwidgets
haikuporter -S -j1 --no-source-packages --get-dependencies kxmlgui
haikuporter -S -j1 --no-source-packages --get-dependencies kbookmarks
haikuporter -S -j1 --no-source-packages --get-dependencies kwallet
haikuporter -S -j1 --no-source-packages --get-dependencies kio
haikuporter -S -j1 --no-source-packages --get-dependencies kdeclarative
haikuporter -S -j1 --no-source-packages --get-dependencies kcmutils
haikuporter -S -j1 --no-source-packages --get-dependencies kinit
haikuporter -S -j1 --no-source-packages --get-dependencies knotifyconfig
haikuporter -S -j1 --no-source-packages --get-dependencies kparts
haikuporter -S -j1 --no-source-packages --get-dependencies kactivities
haikuporter -S -j1 --no-source-packages --get-dependencies kded
haikuporter -S -j1 --no-source-packages --get-dependencies kplotting
haikuporter -S -j1 --no-source-packages --get-dependencies kdesignerplugin
haikuporter -S -j1 --no-source-packages --get-dependencies breeze_icons
haikuporter -S -j1 --no-source-packages --get-dependencies kdelibs4support
haikuporter -S -j1 --no-source-packages --get-dependencies kross
haikuporter -S -j1 --no-source-packages --get-dependencies kdiagram
haikuporter -S -j1 --no-source-packages --get-dependencies attica
haikuporter -S -j1 --no-source-packages --get-dependencies kdnssd
haikuporter -S -j1 --no-source-packages --get-dependencies kfilemetadata
haikuporter -S -j1 --no-source-packages --get-dependencies kholidays
haikuporter -S -j1 --no-source-packages --get-dependencies kjs
haikuporter -S -j1 --no-source-packages --get-dependencies khtml
haikuporter -S -j1 --no-source-packages --get-dependencies kidletime
haikuporter -S -j1 --no-source-packages --get-dependencies kimageformats
haikuporter -S -j1 --no-source-packages --get-dependencies knewstuff
haikuporter -S -j1 --no-source-packages --get-dependencies ksyntax_highlighting
haikuporter -S -j1 --no-source-packages --get-dependencies ktexteditor
haikuporter -S -j1 --no-source-packages --get-dependencies phonon_gstreamer

haikuporter -S -j1 --no-source-packages --get-dependencies oxygen-icons
haikuporter -S -j1 --no-source-packages --get-dependencies kirigami
haikuporter -S -j1 --no-source-packages --get-dependencies kpty
haikuporter -S -j1 --no-source-packages --get-dependencies plasma
