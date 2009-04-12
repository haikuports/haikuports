#!/bin/sh

HOMEPAGE="http://www.bzip.org/"
PACKAGE="app-arch/bzip2/"
VERSION="1.0.5"
URL="http://www.bzip.org/1.0.5/"
FILE="bzip2-1.0.5.tar.gz"

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
cd bzip2-1.0.5
make PREFIX=${PFX} && make install PREFIX=${PFX} && echo  && echo "  Installation complete." || echo "  Installation FAILED !"


echo "  For more information, see:"
echo "    ${HAIKUPORTS}${PACKAGE}"
echo "    ${HOMEPAGE}"
echo
