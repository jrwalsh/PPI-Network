#!/usr/bin/env perl

use strict;
use warnings;

# First, arrange links to make it easier to detect recipricals
print "Ordering links\n";
my $filename = 'out.tmp';
open(my $fh, '>', $filename) or die "Could not open file '$filename' $!";
while (my $line = <>) {
	chomp $line;
	my @fields = split(" ",$line);
	if ($fields[0] lt $fields[1]) {
		print $fh "$fields[0]\t$fields[1]\t$fields[2]\t$fields[3]\t$fields[4]\t$fields[5]\t$fields[6]\t$fields[7]\n";
	} else {
		print $fh "$fields[1]\t$fields[0]\t$fields[3]\t$fields[2]\t$fields[6]\t$fields[7]\t$fields[4]\t$fields[5]\n";
	}
}
close $fh;

# Then, sort and remove reciprical links
print "Removing reciprical links\n";
`sort out.tmp | uniq > out.tmp2`;

# Finally, count
print "Counting links\n";
my $inFile = "out.tmp2";
my $outFile = "out";
open (my $in, '<', $inFile) or die "could not open infile";
open (my $out, '>', $outFile) or die "could not open outfile";
my $a="";
my $b="";
my $ad="";
my $bd="";
my $totalCount = 0;
my $uniqueCount = 0;
print $out "GeneA\tGeneB\tTotalCount\tUniqueCount\n";
while (my $line = <$in>) {
    chomp $line;
    my @fields = split(" ",$line);
    if ($a eq "") {
    	$totalCount = 1;
		$uniqueCount = 1;
    	$a=$fields[0];
    	$b=$fields[1];
    	$ad=$fields[2];
    	$bd=$fields[3];
    } elsif ($a eq $fields[0]) {
		if ($b eq $fields[1]) {
			if ($ad eq $fields[2]) {
				if ($bd eq $fields[3]) {
					$totalCount = $totalCount + 1; # Another copy of the same domain-domain interaction
				} else {
					$totalCount = $totalCount + 1; # A new interacting domain on gene b
					$uniqueCount = $uniqueCount + 1;
					$bd = $fields[3];
				}
			} else {
				$totalCount = $totalCount + 1; # A new interacting domain on gene a
				$uniqueCount = $uniqueCount + 1;
				$ad = $fields[2];
				$bd = $fields[3];
			}
		} else {
			print $out "$a\t$b\t$totalCount\t$uniqueCount\n";
			$totalCount = 1;
			$uniqueCount = 1;
			$b=$fields[1]; # New gene-gene interaction
    		$ad=$fields[2];
    		$bd=$fields[3];
		}
	} else {
		print $out "$a\t$b\t$totalCount\t$uniqueCount\n";
		$totalCount = 1;
		$uniqueCount = 1;
		$a=$fields[0];
    	$b=$fields[1];
    	$ad=$fields[2];
    	$bd=$fields[3];
	}
}
close $in;
close $out;


# Merge gene columns with a "." delimiter in out file
`paste -d . <(cut -f1 out) <(cut -f2,3,4 out) > out.merge`;

# Sort predictable HC interactions before merge
`../../../Perl/sortRowsInPlace.pl ../../../Data/Arabidopsis/predictable\ HC\ interactions > pred.sort`;

# Merge gene columns with a "." delimiter in predictable file
`paste -d . <(cut -f1 pred.sort) <(cut -f2 pred.sort) > pred.merge`;

# Join out and predictable on the now merged column, effectively giveing a join on two key columns instead of one
`join <(sort out.merge) <(sort pred.merge) > hc_counts`;

# Split the key column back out again
`sed -e 's/\\./ /g' hc_counts > hc_counts.final`;