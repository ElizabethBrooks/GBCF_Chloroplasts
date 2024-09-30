#!/bin/bash

# script to subset and rename genome sequences
# usage: bash subset_genomes_renamed.sh

# retrieve input file
inputFile="/Users/bamflappy/GBCF/JRS/chloroplast/Juglanschlorosaln_long.flt.fa"

# set output file dir
outDir=$(dirname $inputFile)
outDir=$outDir"/chloroplast_genomes_renamed"

# retrieve indexing file
indexFile="/Users/bamflappy/Repos/GBCF_Chloroplasts/inputs/chloroplasts_IDindicies.tsv"

# make genomes subset dir
mkdir $outDir 
#Check if the folder already exists
if [ $? -ne 0 ]; then
	echo "The $outDir directory already exsists... please remove before proceeding."
	exit 1
fi

# status message
echo "Beginning analysis..."

# split the sequences and output separate files
while read line; do
	# determine if current line is a header or body
	if echo $line | grep -q ">"; then # header
		# status message
		echo "Processing "$line
		# retrieve genome index and species name
		outID=$(cat $indexFile | grep "$line" | cut -f1)
		outSpec=$(cat $indexFile | grep "$line" | cut -f6 | sed "s/Juglans /J/g" | tr -dc '[:alnum:]')
		# create output name
		outName=$outSpec"_"$outID
		# output new name with file name for the pangenome cactus inputs file
		echo $outName" "$outDir"/"$outName".fa" >> $outDir"/inputs_pangenome_cactus.txt"
	else # body
		# output genome sequence header and body
		echo ">chloroplast" > $outDir"/"$outName".fa"
		echo $line | sed "s/=//g" >> $outDir"/"$outName".fa"
		# add to combined fasta
		echo ">"$outName >> $outDir"/chloroplast_genomes_renamed.fa"
		echo $line | sed "s/=//g" >> $outDir"/chloroplast_genomes_renamed.fa"
	fi
done < $inputFile

# status message
echo "Analysis complete!"
