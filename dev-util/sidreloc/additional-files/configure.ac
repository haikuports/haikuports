AC_PREREQ([2.69])
AC_INIT([sidreloc], [1.0], [linus@linusakesson.net], , [http://www.linusakesson.net/software/sidreloc])

AC_CONFIG_MACRO_DIRS([m4])

AM_INIT_AUTOMAKE([foreign])

AC_CONFIG_SRCDIR([./cpu.c])
AC_CONFIG_HEADERS([config.h])

# Checks for programs.
AC_PROG_CC
AC_PROG_INSTALL

# Checks for header files.
AC_CHECK_HEADERS([stdint.h stdlib.h string.h stdarg.h err.h errno.h])

AC_SEARCH_LIBS([err], [bsd])
AC_SEARCH_LIBS([errx], [bsd])

# Enable BSD extensions
AX_CHECK_COMPILE_FLAG([-D_DEFAULT_SOURCE], AC_SUBST([ENABLE_BSD], [-D_DEFAULT_SOURCE]))

AC_DEFINE_UNQUOTED([RELEASE], ["$PACKAGE_VERSION"], [convenience define used for release number])

# Checks for typedefs, structures, and compiler characteristics.
AC_C_INLINE
AC_TYPE_INT8_T
AC_TYPE_UINT16_T
AC_TYPE_UINT8_T

# Checks for library functions.
AC_FUNC_MALLOC
AC_CHECK_FUNCS([memset err errx])

AC_CONFIG_FILES([Makefile])
AC_OUTPUT

echo \
"-------------------------------------------------

${PACKAGE_NAME} Version ${PACKAGE_VERSION}

Prefix: '${prefix}'.
Compiler: '${CC} ${CFLAGS} ${CPPFLAGS}'

Now type 'make @<:@<target>@:>@'
   where the optional <target> is:
     all                - build sidreloc binary
     install            - install everything

--------------------------------------------------"