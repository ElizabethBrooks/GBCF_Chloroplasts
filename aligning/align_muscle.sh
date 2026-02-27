#!/bin/bash

# script to run muscle for each gene
# usage: bash align_muscle.sh geneID
# usage: bash align_muscle.sh rpl2_1

# retrieve input gene ID
geneID=$1

# retrieve inputs and outputs directory path
outputDir=$(grep "outputs:" ../inputs/inputs_local.txt | tr -d " " | sed "s/outputs://g")

# setup inputs directory
inputsDir=$outputDir"/features_gffread_blatX_hits"

# setup outputs directory
outputFolder=$outputDir"/aligned_muscle"

# make output subdirectory
mkdir $outputFolder

# move to the new directory
cd $outputFolder

# setup formatted inputs directory
dataFolder=$outputFolder"/data"

# make output subdirectory
mkdir $dataFolder

# loop over each protein file
for i in $inputsDir"/"*"_cds.fa"; do 
	# retrieve species tag
	queryTag=$(basename $i | sed "s/_cds.fa//g")
	# setup outputs file
	inFile=$dataFolder"/"$queryTag"_"$geneID"_cds.fa"
	# retrieve the selected gene and clean up IDs by removing hyphens
	cat $i | tr '\n' '!' | sed "s/!>/\n>/g" | grep -m 1 $geneID | sed "s/!/\n/g" | sed "s/>cds-blatx_/>$queryTag\_/g" | sed "s/\ loc:.*$//g" > $inFile
done

# setup inputs and outputs files
queryFile=$dataFolder"/"$geneID"_cds.fa"
outputsFile=$outputFolder"/"$geneID"_cds.aligned.fa"

# combine protein files for the current gene
cat $dataFolder"/J"*"_"$geneID"_cds.fa" > $queryFile

# add a final newline
echo >> $queryFile

# status message
echo "Beginning analysis..."

# run muscle and align protein sequences for the current gene
muscle -align $queryFile -output $outputsFile

# status message
echo "Analysis complete!"
