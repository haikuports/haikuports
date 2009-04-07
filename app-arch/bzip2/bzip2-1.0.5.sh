#!/bin/sh

PACKAGE="app-arch/bzip2"
VERSION="1.0.5"
HOMEPAGE="http://www.bzip.org/"
URL="http://www.bzip.org/1.0.5/"
FILE="bzip2-1.0.5.tar.gz"

PFX=/boot/common
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
cd bzip2-1.0.5

make PREFIX=${PFX} && make install PREFIX=${PFX} && echo  && echo "  Installation complete." || echo "  Installation FAILED !"


echo "  For more information, see ${HAIKUPORTS}/${PACKAGE}"
echo
