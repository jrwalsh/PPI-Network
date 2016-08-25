#!/bin/bash
cd ~/Desktop/PPI\ Network/PFam/PfamScan/
./pfam_scan.pl \
	-out ~/Desktop/PPI\ Network/outfile_ara.results \
	-fasta ~/Desktop/PPI\ Network/Gene\ Model\ Sets/Ara/Araport11_genes.201606.pep.fasta \
	-dir ~/Desktop/PPI\ Network/PFam/PfamScanDataFiles \
	-e_seq 1e-10 
