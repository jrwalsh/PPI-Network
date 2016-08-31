#!/usr/bin/env perl

use strict;
use warnings;

if ($#ARGV < 0) {
	print q{
=============================================================
|                                                           |
|             Coded by Jesse R. Walsh - 2016                |
|                                                           |
|-----------------------------------------------------------|
|-----------------------------------------------------------|
|                                                           |
=============================================================
};
	exit;
} elsif ($#ARGV < 3) {
	print "Please provide all required arguments\n";
	exit;
}

my $pfamPredictions = $ARGV[0];
my $DDIFile = $ARGV[1];
my $org = $ARGV[2];
my $resultsDir = $ARGV[3];

for (my $i=0; $i <= 9; $i++) {
	# Shuffle DDI file and split into 10% test and 90% training sets
	print "Randomizing DDI file and selecting training set\n";
	`shuf $DDIFile > $DDIFile.shuf`;
	my $count = `wc -l < $DDIFile.shuf`;
	die "wc failed: $?" if $?;
	chomp($count);
	$count = int($count/10);
	print `head -n $count $DDIFile.shuf > $resultsDir/test.split`;
	$count = int($count + 1);
	print `tail -n +$count $DDIFile.shuf > $resultsDir/train.split`;
	
	# Call the generateInteractions.pl script on the training set
	print "Generating interactions\n";
	my @ARGS = ($ARGV[0], "$resultsDir/train.split", $ARGV[2], $ARGV[3]); 
	system($^X, "generateInteractions.pl", @ARGS);
	
	# Collect results and store in file
	my $hcSize = `wc -l $resultsDir/test.split`;
	my @hcSize = split / /, $hcSize;
	my $predictions = `wc -l $resultsDir/gene_interactions`;
	my @predictions = split / /, $predictions;
	my $TP = `grep -xF -f $resultsDir/test.split $resultsDir/gene_interactions  | wc -l`;
	my @TP = split / /, $TP;
	print "$hcSize[0]\t$predictions[0]\t$TP[0]\n";
	`echo "$hcSize[0]\t$predictions[0]\t$TP[0]" >> $resultsDir/results`;
	
	`rm $DDIFile.shuf`;
	`rm $resultsDir/test.split`;
	`rm $resultsDir/train.split`;
}
