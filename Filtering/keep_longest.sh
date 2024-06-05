#!/bin/bash

# script to convert an input multiline fasta to single
# usage: bash keep_longest.sh inputFile
# usage: bash keep_longest.sh /Users/bamflappy/GBCF/JRS/chloroplast/Juglanschlorosaln.fmt.fa

# retrieve input file
inputFile=$1

# retrieve genome lengths data file
lengthsFile=$(dirname $inputFile)
lengthsFile=$lengthsFile"/longest_genome.csv"

# set output file name
outputFile=$(echo $inputFile | sed "s/\.fmt\.fa//g")
outputFile=$outputFile"_longest.flt.fa"

# pre-clean up
rm $outputFile

# loop over the IDs of the longest genomes and retrieve the corresponding sequences
while read line; do
	# find current gene ID and retrieve sequence
	cat $inputFile | grep -A1 "$line" >> $outputFile
done < $lengthsFile
