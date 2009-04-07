#!/bin/sh

PACKAGE="app-admin/pwgen"
VERSION="2.06"
HOMEPAGE="http://sourceforge.net/projects/pwgen/"
URL="http://voxel.dl.sourceforge.net/sourceforge/pwgen/"
FILE="pwgen-2.06.tar.gz"

PREFIX=--prefix=/boot/common
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
cd pwgen-2.06
configure ${PREFIX}
`make && make install && echo  && echo "  Installation complete."` || echo "  Installation FAILED !"

echo "  For more information, see ${HAIKUPORTS}/${PACKAGE}"
echo