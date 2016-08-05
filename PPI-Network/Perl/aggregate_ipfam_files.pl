#!/usr/bin/env perl

use strict;
use warnings;

my $dir="./families";

opendir (my $dh, $dir) or die "cannot open directory $dir\n";
my @docs = readdir($dh);
open (my $out, '>',"$dir/iPfam_interactions.csv") or die "could not open outfile";

print $out "domain	partner domain	accession	number of occurrences	number intrachain	number interchain\n";

foreach my $filename (@docs) {
	open (my $data, '<', "$dir/$filename") or die "could not open file $filename in directory $dir\n$!\n";
	my $line = <$data>;
	while ($line = <$data>) {
		chomp $line;
		if ($line ne "") {
			$filename =~ s/.csv//g;
			print $out "$filename\t$line\n";
		}
	}
}
close $out;
print "done\n";
