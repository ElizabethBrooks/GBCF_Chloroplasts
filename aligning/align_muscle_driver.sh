#!/bin/bash

# script to run muscle for each gene
# usage: bash align_muscle_driver.sh

# retrieve chloroplast annotations
chloroAnnot=$(grep "annotationsChloroplasts:" ../inputs/inputs_local.txt | tr -d " " | sed "s/annotationsChloroplasts://g")

# setup inputs file
inputsFile=$chloroAnnot"/blatX_hits/Jailantifolia_136_blatx_gene_list.txt"

# retrieve inputs and outputs directory path
outputDir=$(grep "outputs:" ../inputs/inputs_local.txt | tr -d " " | sed "s/outputs://g")

# setup inputs directory
inputsDir=$outputDir"/features_gffread_blatX_hits"

# setup outputs directory
outputFolder=$outputDir"/aligned_muscle"

# setup formatted inputs directory
dataFolder=$outputFolder"/data"

# loop over each gene ID
while read line; do
	# status message
	echo "Processing gene $line ..."
	# run alignment script
	bash align_muscle.sh $line
done < $inputsFile

# clean up
#rm -r $dataFolder

# status message
echo "Processed!"
