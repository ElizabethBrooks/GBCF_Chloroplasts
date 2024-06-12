#!/bin/bash

# script to find the longest sequence in a fasta file
# usage: bash find_long.sh inputFile
# usage: bash find_long.sh /Users/bamflappy/GBCF/JRS/chloroplast/genome_lengths.csv

# retrieve input file
inputFile=$1

# set output file name
outputFile=$(dirname $inputFile)
outputFile=$outputFile"/long_genomes.csv"

# filter sequences by lengths
awk -F ',' '{ print $1 "," $NF }' $inputFile | sed "s/-_/ /g" | sed "s/, /,/g" | awk -F ',' '$2 > 159700' | cut -d "," -f1 > $outputFile
