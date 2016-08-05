#!/usr/bin/env perl

use strict;
use warnings;

while (my $line = <>) {
        chomp $line;
        my @fields = split(" ",$line);
        if ($fields[0] lt $fields[1]) {
		print "$fields[0]\t$fields[1]\n";
	} else {
		print "$fields[1]\t$fields[0]\n";
	}
}
