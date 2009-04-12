#!/bin/sh

HOMEPAGE="http://www.gnu.org/software/gzip/"
PACKAGE="app-arch/gzip/"
VERSION="1.3.12"
URL="http://ftp.gnu.org/gnu/gzip/"
FILE="gzip-1.3.12.tar.gz"
PATCH_URL="http://ports.haiku-files.org/svn/haikuports/trunk/"
PATCH_FILE="gzip-1.3.12-downstream.patch"

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
cd gzip-1.3.12
wget ${PATCH_URL}${PACKAGE}/${PATCH_FILE}
patch -p1 -i ${PATCH_FILE}
libtoolize --force --install
configure --prefix=${PFX}
make && make install && echo  && echo "  Installation complete." || echo "  Installation FAILED !"

echo "  For more information, see:"
echo "    ${HAIKUPORTS}${PACKAGE}"
echo "    ${HOMEPAGE}"
echo

