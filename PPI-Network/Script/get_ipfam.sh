#!/bin/bash
# @Author Jesse R. Walsh 7/19/2016

# Input = file produced by pfam_scan.pl
# Input file is expected to have a 28-line header and have the pfam family listed in column 6, columns separated by multiple spaces which need to be condensed, and pfam family accessions have a suffix consisting of a period and one or two digits.

cd ~/Desktop/PPI\ Network/iPfam

while read -r line; do
   FOUND=$(find ./families/ -type f -name $line.csv)
   [ ! -z "$FOUND" ] && echo Found already downloaded, skipping $line || curl -o "./families/$line.csv" --data "data_set=fam_int" "http://ipfam.org/family/$line/download"
done < <(tail -n +29 $1 | tr -s ' ' | cut --d ' ' -f6 | sed -e 's/\.[0-9][0-9]\?//g')

# Clean up the iPfam interaction files by moving terms not found to "./missing" and terms with not interactions to "./empty"
cd ~/Desktop/PPI\ Network/iPfam/families
grep -Z -l "has moved" ./*.csv | xargs -0 -I{} mv {} missing/
find . -size 84c | xargs -I{} mv {} empty/
 
