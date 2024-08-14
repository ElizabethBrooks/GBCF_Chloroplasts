#!/bin/bash

# script to subset genome sequences from a fasta file
# usage: bash subset_genomes.sh inputFile
# usage: bash subset_genomes.sh /Users/bamflappy/GBCF/JRS/chloroplast/Juglanschlorosaln_long.flt.fa

# retrieve input file
inputFile=$1

# set output file dir
outDir=$(dirname $inputFile)
outDir=$outDir"/chloroplast_genomes"

# make genomes subset dir
mkdir $outDir 

# split the sequences and output separate files
while read line; do
	# determine if current line is a header or body
	if echo $line | grep -q ">"; then # header
		# store header
		header=$line
		# create file name
		outName=$(echo $header | sed "s/ /_/g" | sed "s/>//g")
	else # body
		# output genome sequence header and body
		echo $header > $outDir"/"$outName".fa"
		echo $line >> $outDir"/"$outName".fa"
	fi
done < $inputFile
