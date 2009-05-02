#!/bin/sh
#
# 
CWD=`pwd`
DOWNLOADS="$CWD/downloads"
DEPS="$CWD/dependencies"
DIRECTORIES=( "$DOWNLOADS" "$DEPS")
WGET_CMD='wget --quiet'
DEP_URLS=( \
'http://git.savannah.gnu.org/gitweb/?p=gnulib.git;a=blob_plain;f=build-aux/config.guess' \
'http://git.savannah.gnu.org/gitweb/?p=gnulib.git;a=blob_plain;f=build-aux/config.sub' \
'http://ftp.gnu.org/gnu/autoconf/autoconf-2.13.tar.gz' \
'http://pkgconfig.freedesktop.org/releases/pkg-config-0.23.tar.gz' \
'http://ftp.mozilla.org/pub/mozilla.org/mozilla/libraries/source/libIDL-0.6.8.tar.gz' )
# ####
# NOTE: currently andrewtv.org is down
#'http://andrewtv.org/static/libIDL/libIDL-0.6.8.tar.gz' \

AUTOCONF_CMD="/boot/apps/autoconf-2.13/bin/autoconf --macro-dir=/boot/apps/autoconf-2.13/share/autoconf"

PREFIX=--prefix=/boot/common

# #################################
# create_dirs ()  
#
function create_dirs ()
{
echo "Creating directory structure ... "
for dir in ${DIRECTORIES[@]}
do 
    if ! [ -d "$dir" ] ; then 
        mkdir -p "$dir"
    fi
done
} # function create_dirs ()


# #################################
# download_deps ()
#
function download_deps ()
{
echo "Downloading necessary dependency source archives ... "

for url in ${DEP_URLS[@]}
do 
    filename=${url##*/}
    if ! [ -e "$DOWNLOADS/$filename" ]; then
        echo "  $filename ..."
        $WGET_CMD --output-document="$DOWNLOADS/$filename" "$url"
    fi
done
} # function download_deps ()


# #################################
# unpack_deps ()
#
function unpack_deps ()
{

echo "Expanding dependency source archives ... "

for archive in "$DOWNLOADS"/*
do
ext=${archive##*.}
file=${archive##*/}

if [ "$ext" = "gz" ]; then
    cd "$DEPS"  
    if ! [ -f "$file"-expanded ]; then
        tar xvf "$archive"
        touch "$file"-expanded
    fi
    cd "$CWD"    
    
fi
done
} # function unpack_deps () 


# #################################
# copy_config_sub ()
#
function copy_config_guess ()
{
cd "$DEPS"
echo "Updating dependencies' config.guess ..."
for result in `find -name config.guess`
do
    echo "$result"
    cp -f "$DOWNLOADS/config.guess" "$result"
done
cd "$CWD"
} # function copy_config_guess ()


# #################################
# copy_config_sub ()
#
function copy_config_sub ()
{

cd "$DEPS"
echo "Updating dependencies' config.sub ..."
for result in `find -name config.sub`
do
	echo "$result"
    cp -f "$DOWNLOADS/config.sub" "$result"
done
cd "$CWD"
} # function copy_config_sub ()


# #################################
# build_autoconf213 ()
#
function build_autoconf213 ()
{
cd "$CWD"'/dependencies/autoconf-2.13'
echo "`pwd`"
./configure --prefix=/boot/apps/autoconf-2.13
make
make install  
cd "$CWD"
} # function build_autoconf213 ()



# #################################
# build_glib ()
# 
# NOTE : TODO : re-do patch, as it does not include configure.in changes
function build_glib ()
{
cd "$CWD"/dependencies/pkg-config-0.23/
echo "`pwd`"
patch -p0 -N -i "$CWD"/pkgconfig_glib-installable-Naur.diff
cd glib-1.2.10
libtoolize --force --copy
aclocal
automake
autoconf
./configure "$PREFIX"
make
make check
make install
cd "$CWD"
} # function build_glib ()


# #################################
# build_libidl ()
#
function build_libidl ()
{
cd "$CWD"/dependencies
cd libIDL-0.6.8
$AUTOCONF_CMD
./configure "$PREFIX"
make
make install
cd "$CWD"
} # function build_libidl ()


# #################################
# print_mozconfig_message () 
#
function print_mozconfig_message ()
{ 
cat <<EOF
####====--------------------------------------------====####
### === ---    THIS MUST GO IN YOUR MOZCONFIG    --- === ###
#
export GLIB_CONFIG=/boot/common/bin/glib-config
mk_add_options GLIB_CONFIG=/boot/common/bin/glib-config

export LIBIDL_CONFIG=/boot/common/bin/libIDL-config
mk_add_options LIBIDL_CONFIG=/boot/common/bin/libIDL-config
#
####====--------------------------------------------====####
EOF

} # function print_mozconfig_message ()
# #################################
# main execution block
#
create_dirs
download_deps
unpack_deps
copy_config_guess
copy_config_sub
build_autoconf213
build_glib
build_libidl
print_mozconfig_message
