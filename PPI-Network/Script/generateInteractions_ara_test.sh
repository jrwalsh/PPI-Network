#!/bin/bash
cd ../Perl/
./generateInteractions.pl \
	../Data/Arabidopsis/pfam_predictions.tab \
	../Data/iPfam/assumed_pfam_interactions.tab \
	Ara \
	../Results/Arabidopsis/newTest3