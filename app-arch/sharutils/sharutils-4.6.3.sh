#!/bin/sh

HOMEPAGE="http://www.gnu.org/software/sharutils/"
PACKAGE="app-arch/sharutils/"
VERSION="4.6.3"
URL="ftp://ftp.gnu.org/gnu/sharutils/REL-4.6.3/"
FILE="sharutils-4.6.3.tar.bz2"
PATCH_URL="http://ports.haiku-files.org/svn/haikuports/trunk/"
PATCH_FILE="sharutils-4.6.3-downstream.patch"

# ------- This should not be edited ------- 
PFX=/boot/common/
HAIKUPORTS="http://ports.haiku-files.org/wiki/"
CWD=`pwd`/
if [ ! -d ${PACKAGE}${VERSION} ] ; then
	mkdir -p ${PACKAGE}${VERSION}
fi
if [ ! -e ${FILE} ] ; then
	wget ${URL}${FILE}
fi
cd ${PACKAGE}${VERSION}
if [ ${FILE:(-7)} = "tar.bz2" ] ; then
	tar -jxvf ${CWD}${FILE}
elif [ ${FILE:(-7)} = ".tar.gz" ] ; then
	tar xvf ${CWD}${FILE}
fi
# ------- Begin Instructions ------- 
cd sharutils-4.6.3
wget ${PATCH_URL}${PACKAGE}${PATCH_FILE}
patch -p1 -i ${PATCH_FILE}
libtoolize --force --install
configure --prefix=${PFX}
aclocal --force -I m4
automake --force-missing --gnits
autoconf --force
make && make install DEST_HOME=${PFX} && echo "  Installation complete." || echo "  Installation FAILED !"

echo "  For more information, see:"
echo "    ${HAIKUPORTS}${PACKAGE}"
echo "    ${HOMEPAGE}"
echo

