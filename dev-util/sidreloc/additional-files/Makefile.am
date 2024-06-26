bin_PROGRAMS = sidreloc
dist_sidreloc_SOURCES = sidreloc.c solver.c cpu.c reloc.h
notrans_dist_man1_MANS = sidreloc.1

sidreloc_CFLAGS=-Wall -std=c99 -O3 -DNDEBUG $(ENABLE_BSD)

check_SCRIPTS = greptest.sh

TESTS = $(check_SCRIPTS)

greptest.sh:
	@echo './sidreloc --version | grep "sidreloc @PACKAGE_VERSION@"' > greptest.sh
	@chmod +x greptest.sh

CLEANFILES = greptest.sh