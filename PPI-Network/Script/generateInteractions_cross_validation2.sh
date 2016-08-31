#!/bin/bash
cd ../Perl/

#split -da 4 --number=l/10 ../Data/iPfam/assumed_pfam_interactions part --additional-suffix=".split"
split -da 4 --number=l/10 test part --additional-suffix=".split"

TRAIN=""
TEST=""
#For each round in the cross validation
for i in {0..1}; do
	
	#Select Training 90% and Testing 10% set
	index=0
	for file in $( ls part* ); do
		this=`cat $file`
		if [ $index -eq 0 ]; then
			TEST=`echo "$this"`
		else
			TRAIN=${TRAIN}$'\n'${this}
		fi
		index=$((index+1))
	done
	
	echo "$TRAIN" > train.split
	echo "$TEST" > test.split
	
	#./generateInteractions.pl ../Data/Arabidopsis/pfam_predictions.tab ../Data/iPfam/train.split Ara ../Results/Arabidopsis/newTest3
	
	#rm train.split
	#rm test.split
done