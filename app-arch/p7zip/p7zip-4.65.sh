#!/bin/sh

HOMEPAGE="http://p7zip.sourceforge.net/"
PACKAGE="app-arch/p7zip/"
VERSION="4.65"
URL="http://voxel.dl.sourceforge.net/sourceforge/p7zip/"
FILE="p7zip_4.65_src_all.tar.bz2"

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
cd p7zip_4.65
cp makefile.beos makefile.machine
make && make install DEST_HOME=${PFX} && echo "  Installation complete." || echo "  Installation FAILED !"

echo "  For more information, see:"
echo "    ${HAIKUPORTS}${PACKAGE}"
echo "    ${HOMEPAGE}"
echo

