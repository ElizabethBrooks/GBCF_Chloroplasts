#!/bin/bash

# script to subset and rename genome sequences
# usage: bash subset_genomes_renamed.sh

# retrieve input file
inputFile="/Users/bamflappy/GBCF/JRS/chloroplast/Juglanschlorosaln_long.flt.fa"

# set output file dir
outDir=$(dirname $inputFile)
outDir=$outDir"/chloroplast_genomes_renamed"

# retrieve indexing file
indexFile="/Users/bamflappy/GBCF/JRS/chloroplast/GBCF_JRS_chloroplasts_IDindicies.csv"

# make genomes subset dir
mkdir $outDir 

# pre-clean up
rm $outDir"/chloroplast_genomes_renamed.fa"

# split the sequences and output separate files
while read line; do
	# determine if current line is a header or body
	if echo $line | grep -q ">"; then # header
		# retrieve genome index
		outName=$(cat $indexFile | grep "\"$line\"" | cut -d"," -f1)
	else # body
		# output genome sequence header and body
		echo ">chloroplast" > $outDir"/IDfileorder"$outName".fa"
		echo $line | sed "s/=//g" >> $outDir"/IDfileorder"$outName".fa"
		# add to combined fasta
		echo ">IDfileorder"$outName >> $outDir"/chloroplast_genomes_renamed.fa"
		echo $line | sed "s/=//g" >> $outDir"/chloroplast_genomes_renamed.fa"
	fi
done < $inputFile
