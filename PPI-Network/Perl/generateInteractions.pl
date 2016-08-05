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
| This program will generate a list of domain-domain,       |
| protein-protein, and gene-gene interactions for an        |
| organism. Requires 3 inputs: a list of pfam domains       |
| predicted for the proteins of this organism, a list of    |
| pfam domains predicted to interact, and an organism code. |
|-----------------------------------------------------------|
| Syntax - generateInteractions.pl                          |
|             pfamPredictions                               |
|             ipfam                                         |
|             organism                                      |
|                -Ara                                       |
|                -Maize                                     |
|                                                           |
=============================================================
};
	exit;
} elsif ($#ARGV < 2) {
	print "Please provide all required arguments\n";
	exit;
}

my $pfamPredictions = $ARGV[0];
my $ipfam = $ARGV[1];
my $org = $ARGV[2];

print "Using $pfamPredictions as pfamPredictions\n" if -p $pfamPredictions;
print "Using $ipfam as ipfam interactions list\n" if -p $ipfam;

# Sort both the pfamPredictions list and the ipfam interactions list
print "Sorting the pfamPredictions and ipfam interaction lists\n";
`(head -n 1 pfam_predictions.tab && tail -n +2 pfam_predictions.tab | sort) > pfam_predictions.tab.sorted`;
`(head -n 1 iPfam_domain_interactions.tab && tail -n +2 iPfam_domain_interactions.tab | sort) > iPfam_domain_interactions.tab.sorted`;

# Join the predictions with the ipfam interactions to generate a list of domain-domain interactions
print "Generating a domain-domain interaction list\n";
`join --header -1 1 -2 1 pfam_predictions.tab.sorted iPfam_domain_interactions.tab.sorted > domain_interactions`;

# Sort the domain-domain interactions
`(head -n 1 domain_interactions && tail -n +2 domain_interactions | sort -k 6) > domain_interactions.sorted`;

# Join the partner domain back to the proteins they were predicted on to generate a protein-protein network
print "Generating a protein-protein interaction list\n";
`join --header -1 6 -2 1 domain_interactions.sorted pfam_predictions.tab.sorted  > protein_interactions.tmp`;

# Remove unused columns in the protein-protein network
`cut --delimiter=" " -f3,8 protein_interactions.tmp > protein_interactions.tmp2`;

# Remove duplication that occurs when the same domain-domain interaction occurs between two proteins
`tail -n +2 protein_interactions.tmp2 | sort | uniq > protein_interactions.tmp3`;

# Remove reciprical links between proteins
my $inFile = "./protein_interactions.tmp3";
my $outFile = "./protein_interactions.tmp4";
open (my $in, '<', $inFile) or die "could not open infile";
open (my $out, '>', $outFile) or die "could not open outfile";

while (my $line = <$in>) {
        chomp $line;
        my @fields = split(" ",$line);
        if ($fields[0] lt $fields[1]) {
		print $out "$fields[0]\t$fields[1]\n";
	} else {
		print $out "$fields[1]\t$fields[0]\n";
	}
}
close $in;
close $out;

`sort protein_interactions.tmp4 | uniq > protein_interactions`;

# Depending on the organism, remove the protein identifiers, leaving only gene-gene interactions
print "Generating a gene-gene interaction list\n";
if ($org eq "Maize") {
	`sed -e 's/_P[0-9][0-9]//g' -e 's/_FGP[0-9][0-9][0-9]//g' protein_interactions > gene_interactions.tmp`;
} elsif ($org eq "Ara") {
	print "Using organism Ara\n";
	`sed -e 's/\\.[0-9][0-9]\\?//g' protein_interactions > gene_interactions.tmp`;
} else {
	print "Unknown organism, I don't know how to merge proteins-protein interactions into gene-gene interactions\n";
	exit;
}

# Remove duplication that occurs when multiple protein-protein interactions exist between 2 genes
`sort gene_interactions.tmp | uniq > gene_interactions`;

# Cleanup unused files
print "Cleaning temporary files\n";
`rm pfam_predictions.tab.sorted`;
`rm iPfam_domain_interactions.tab.sorted`;
#`rm domain_interactions`;
`rm domain_interactions.sorted`;
`rm protein_interactions.tmp`;
`rm protein_interactions.tmp2`;
`rm protein_interactions.tmp3`;
`rm protein_interactions.tmp4`;
#`rm protein_interactions`;
`rm gene_interactions.tmp`;
#`rm gene_interactions`;

print "Done!\n";
