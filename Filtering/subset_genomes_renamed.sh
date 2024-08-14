#!/bin/bash

# script to subset genome sequences from a fasta file
# usage: bash subset_genomes_renamed.sh inputFile
# usage: bash subset_genomes_renamed.sh /Users/bamflappy/GBCF/JRS/chloroplast/Juglanschlorosaln_long.flt.fa

# retrieve input file
inputFile=$1

# set output file dir
outDir=$(dirname $inputFile)
outDir=$outDir"/chloroplast_genomes_renamed"

# make genomes subset dir
mkdir $outDir 

# split the sequences and output separate files
while read line; do
	# determine if current line is a header or body
	if echo $line | grep -q ">"; then # header
		# create file name
		outName=$(($outName + 1))
	else # body
		# output genome sequence header and body
		echo ">"$outName > $outDir"/"$outName".fa"
		echo $line >> $outDir"/"$outName".fa"
	fi
done < $inputFile
