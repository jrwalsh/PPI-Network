#!/bin/bash
# @Author Jesse R. Walsh 8/11/2016

cd ~/Desktop/PPI\ Network/PFam/PfamScan/
./pfam_scan.pl \
	-out ~/Desktop/PPI\ Network/outfile_ara.results \
	-fasta ~/Desktop/PPI\ Network/Gene\ Model\ Sets/Ara/Araport11_genes.201606.pep.fasta \
	-dir ~/Desktop/PPI\ Network/PFam/PfamScanDataFiles 

less outfile_ara.results
tail -n +29 outfile_ara.results | tr -s ' ' | cut --d ' ' -f1,2,3,6,8,12,13 > pfam_predictions.tab


# Convert output to the following columns,  first print column headers
echo -e 'pred_domain\tgene\ttype\tscore\teval\tstart\tend' > pfam_predictions.tab

# Ignore the pfam_scan headers, condense spaces, cut only desired columns to keep, remove decimals in pfam domain names, rearrange columns and use tabs, and append to new file
tail -n +29 outfile_ara.results | tr -s ' ' | cut --d ' ' -f1,2,3,6,8,12,13 | awk '{gsub(/\..*$/,"",$4)}1'| awk -v OFS='\t' '{print $4, $1, $5, $6, $7, $2, $3}' >> pfam_predictions.tab