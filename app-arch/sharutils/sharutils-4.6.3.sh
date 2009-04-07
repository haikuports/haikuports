#!/bin/sh

PACKAGE="app-arch/sharutils"
VERSION="4.6.3"
HOMEPAGE="http://www.gnu.org/software/sharutils/"
URL="ftp://ftp.gnu.org/gnu/sharutils/REL-4.6.3/"
FILE="sharutils-4.6.3.tar.bz2"
PATCH_URL="http://ports.haiku-files.org/export/282/haikuports/trunk/app-arch/sharutils/"
PATCH_FILE="sharutils-4.6.3-downstream.patch"

PREFIX=/boot/common
HAIKUPORTS="http://ports.haiku-files.org/wiki"
CWD=`pwd`

if [ ! -d ${PACKAGE}/${VERSION} ] ; then
	mkdir -p ${PACKAGE}/${VERSION}
fi
if [ ! -e ${FILE} ] ; then
	wget ${URL}${FILE}
fi
cd ${PACKAGE}/${VERSION}
tar -jxvf ${CWD}/${FILE}
cd sharutils-4.6.3
wget ${PATCH_URL}${PATCH_FILE}
patch -p1 -i ${PATCH_FILE}
libtoolize --force --install
configure --prefix=${PREFIX}
aclocal --force -I m4
automake --force-missing --gnits
autoconf --force
make && make install DEST_HOME=${PREFIX} && echo "  Installation complete." || echo "  Installation FAILED !"

echo "  For more information, see ${HAIKUPORTS}/${PACKAGE}"
echo
