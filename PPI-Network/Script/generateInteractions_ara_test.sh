#!/bin/bash
cd ../Perl/
./generateInteractions.pl \
	../Data/Arabidopsis/pfam_predictions.tab \
	../Data/iPfam/iPfam_domain_interactions.tab \
	Ara \
	../Results/Arabidopsis/newTest