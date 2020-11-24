AC_PREREQ([2.69])
AC_INIT([irrxml], [1.2], [], , [https://www.ambiera.com/irrxml])
AC_CONFIG_SRCDIR([example/test.cpp])
AC_CONFIG_HEADERS([config.h])
AM_INIT_AUTOMAKE

LT_INIT

AC_CONFIG_MACRO_DIRS([m4])

AM_INIT_AUTOMAKE([foreign])

# Checks for programs.
AC_PROG_CXX
AC_PROG_CC
AC_PROG_CPP

# Checks for libraries.

# Checks for header files.
AC_CHECK_HEADERS([stdlib.h])

# Checks for typedefs, structures, and compiler characteristics.
AC_CHECK_HEADER_STDBOOL
AC_C_INLINE

# Checks for library functions.
AC_CHECK_FUNCS([pow strtol])

AC_CONFIG_FILES([irrxml.pc Makefile])
AC_OUTPUT
