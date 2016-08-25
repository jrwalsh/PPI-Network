#!/bin/bash
cd ~/Desktop/PPI\ Network/PFam/PfamScan/
./pfam_scan.pl \
	-out ~/Desktop/PPI\ Network/outfile_v2.results \
	-fasta ~/Desktop/PPI\ Network/Gene\ Model\ Sets/FGS_v2/ZmB73_5b.60_filtered.translations.fasta \
	-dir ~/Desktop/PPI\ Network/PFam/PfamScanDataFiles 
