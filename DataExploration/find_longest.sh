#!/bin/bash

# script to convert an input multiline fasta to single
# usage: bash find_longest.sh inputFile
# usage: bash find_longest.sh /Users/bamflappy/GBCF/JRS/chloroplast/genome_lengths.csv

# retrieve input file
inputFile=$1

# set output file name
outputFile=$(dirname $inputFile)
outputFile=$outputFile"/longest_genome.csv"

# filter sequences by lengths
awk -F ',' '{ print $1 "," $NF }' $inputFile | sed "s/-_/ /g" | sed "s/, /,/g" | awk -F ',' '$2 > 160400' | cut -d "," -f1 > $outputFile
