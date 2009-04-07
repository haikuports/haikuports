#!/bin/sh

PACKAGE="app-arch/p7zip"
VERSION="4.65"
HOMEPAGE="http://p7zip.sourceforge.net/"
URL="http://voxel.dl.sourceforge.net/sourceforge/p7zip/"
FILE="p7zip_4.65_src_all.tar.bz2"

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
cd p7zip_4.65
cp makefile.beos makefile.machine
make && make install DEST_HOME=${PREFIX} && echo "  Installation complete." || echo "  Installation FAILED !"

echo "  For more information, see ${HAIKUPORTS}/${PACKAGE}"
echo
