#!/bin/sh

PACKAGE="app-arch/fastjar"
VERSION="0.97"
HOMEPAGE="https://savannah.nongnu.org/projects/fastjar"
URL="http://mirror.its.uidaho.edu/pub/savannah/fastjar/"
FILE="fastjar-0.97.tar.gz"

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
cd fastjar-0.97
libtoolize --force --install
aclocal --force 
automake --force-missing
autoconf --force
configure --prefix=${PREFIX} 
make && make install && echo  && echo "  Installation complete." || echo "  Installation FAILED !"

echo "  For more information, see ${HAIKUPORTS}/${PACKAGE}"
echo
