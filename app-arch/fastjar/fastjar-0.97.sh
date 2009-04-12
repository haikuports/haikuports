#!/bin/sh

HOMEPAGE="https://savannah.nongnu.org/projects/fastjar/"
PACKAGE="app-arch/fastjar/"
VERSION="0.97"
URL="http://mirror.its.uidaho.edu/pub/savannah/fastjar/"
FILE="fastjar-0.97.tar.gz"

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
cd fastjar-0.97
libtoolize --force --install
aclocal --force 
automake --force-missing
autoconf --force
configure --prefix=${PREFIX} 
make && make install && echo  && echo "  Installation complete." || echo "  Installation FAILED !"

echo "  For more information, see:"
echo "    ${HAIKUPORTS}${PACKAGE}"
echo "    ${HOMEPAGE}"
echo

