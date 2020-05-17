AC_INIT([wcstools], [3.9.5] , [http://tdc-www.harvard.edu/wcstools/])
AM_INIT_AUTOMAKE([foreign])

AC_CONFIG_HEADERS([config.h])
AC_CONFIG_FILES([libwcs/Makefile Makefile wcstools.pc])
AC_CONFIG_MACRO_DIRS([m4])

AC_CANONICAL_HOST

AC_PROG_CC
AC_PROG_LIBTOOL

LT_INIT([disable-static])

AC_CHECK_HEADERS([fcntl.h])
AC_CHECK_LIB([m], [sin])

AS_CASE([$host_os],[haiku*], [
    AC_CHECK_LIB([network], [listen], [], [AC_MSG_ERROR([listen wa not found in Haiku -lnetwork])])
    LDFLAGS="-lnetwork $LDFLAGS"
])

AC_SUBST([LDFLAGS])

AC_OUTPUT
