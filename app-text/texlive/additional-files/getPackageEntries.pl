#!/bin/perl
# Copyright 2021, Joachim Mairböck <j.mairboeck@gmail.com>
# Distributed under the terms of the MIT license.

# Helper script to get the packageEntries for texlive subpackages
# usage:
# 	perl -I $sourceDir/tlpkg getPackageEntries.pl <prefix> <collectionname>
#
#	<prefix> is the root of the installation, containing tlpkg/texlive.tlpdb, i.e. $dataDir/texlive/
#	<collectionname> is the base name of the subpackage without prefix
#
# This script uses the TeXLive perl modules, therefore it needs $sourceDir/tlpkg in @INC.

use strict;
use warnings;

use TeXLive::TLPDB;

my $tlpdb = TeXLive::TLPDB->new(root => $ARGV[0]);
my ($collection, $suffix) = split "_", $ARGV[1];
my $tlpkg = $tlpdb->get_package("collection-$collection");
my @depnames = $tlpkg->depends();

foreach my $depname (@depnames) {
	my $deppkg = $tlpdb->get_package($depname);
	my $filesfield = do {
		unless (defined $suffix) { "runfiles" }
		elsif ($suffix eq "doc") { "docfiles" }
		elsif ($suffix eq "source") { "srcfiles" }
	};
	my @files = @{$deppkg->{$filesfield}};
	foreach my $filename (@files) {
		my $path = $ARGV[0] . $filename;
		print $path, "\n" if -e $path; # ignore missing files
	}
}
