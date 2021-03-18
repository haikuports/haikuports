#/bin/sh

source ~/config/settings/haikuports.conf
cd "$TREE_PATH"/kde-frameworks/

old_version=5.80
new_version=5.80

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
sed -i "s/$CHECKSUM_SHA256/`curl -s -L $SOURCE_URI | sha256sum | head -c 64`/" $FNAME ; done


exit 0

# the recipes should be built in this order

hp extra_cmake_modules
hp phonon
hp karchive
hp kcodecs
hp kconfig
hp kcoreaddons
hp kdbusaddons
hp kguiaddons
hp ki18n
hp kitemmodels
hp kitemviews
hp kwidgetsaddons
hp kwindowsystem
hp solid
hp sonnet
hp threadweaver
hp kauth
hp kcompletion
hp kcrash
hp kdoctools
hp kunitconversion
hp kconfigwidgets
hp kservice
hp kglobalaccel
hp kpackage
hp kemoticons
hp kiconthemes
hp kjobwidgets
hp knotifications
hp ktextwidgets
hp kxmlgui
hp kbookmarks
hp kwallet
hp kio
hp kdeclarative
hp kcmutils
hp kinit
hp knotifyconfig
hp kparts
hp kactivities
hp kded
hp kplotting
hp kdesignerplugin
hp breeze_icons
hp kdelibs4support
hp kross
hp kdiagram
hp attica
hp kdnssd
hp kfilemetadata
hp kholidays
hp kjs
hp khtml
hp kidletime
hp kimageformats
hp knewstuff
hp ksyntax_highlighting
hp ktexteditor
hp phonon_gstreamer

#hp oxygen-icons
hp kirigami
hp kpty
hp plasma
