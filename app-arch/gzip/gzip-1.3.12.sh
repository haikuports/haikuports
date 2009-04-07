#!/bin/sh

PACKAGE="app-arch/gzip"
VERSION="1.3.12"
HOMEPAGE="http://www.gnu.org/software/gzip/"
URL="http://ftp.gnu.org/gnu/gzip/"
FILE="gzip-1.3.12.tar.gz"
PATCH_URL="http://ports.haiku-files.org/svn/haikuports/trunk/"
PATCH_FILE="gzip-1.3.12-downstream.patch"

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
tar xvf ${CWD}/${FILE}
cd gzip-1.3.12
svn export ${PATCH_URL}${PACKAGE}/${PATCH_FILE}
patch -p1 -i ${PATCH_FILE}
libtoolize --force --install
configure --prefix=${PREFIX}
make && make install && echo  && echo "  Installation complete." || echo "  Installation FAILED !"

echo "  For more information, see ${HAIKUPORTS}/${PACKAGE}"
echo
