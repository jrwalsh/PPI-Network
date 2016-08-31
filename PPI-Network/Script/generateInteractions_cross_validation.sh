#!/bin/bash
cd ../Perl/
./generateInteractions_cross_validation.pl \
	../Data/Arabidopsis/pfam_predictions.tab \
	../Data/iPfam/assumed_pfam_interactions_counts \
	Ara \
	../Results/Arabidopsis/newTest4