AM_CPPFLAGS = -I./src
ACLOCAL_AMFLAGS= -I m4

check_PROGRAMS = irrxml
irrxml_SOURCES = example/test.cpp
irrxml_LDADD = libirrxml.la

pkginclude_HEADERS = \
src/CXMLReaderImpl.h  src/fast_atof.h  src/heapsort.h  src/irrArray.h \
src/irrString.h       src/irrTypes.h   src/irrXML.h

lib_LTLIBRARIES = libirrxml.la
libirrxml_la_SOURCES = src/irrXML.cpp
libirrxml_la_LDFLAGS = -no-undefined -shared
libirrxml_la_CPPFLAGS = -fPIC

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = irrxml.pc
