#!/bin/bash
cd ~/Desktop/PPI\ Network/PFam/PfamScan/
./pfam_scan.pl \
	-out ~/Desktop/PPI\ Network/outfile_v3.results \
	-fasta ~/Desktop/PPI\ Network/Gene\ Model\ Sets/v3/Zea_mays.AGPv3.21.pep.all.fa \
	-dir ~/Desktop/PPI\ Network/PFam/PfamScanDataFiles 
