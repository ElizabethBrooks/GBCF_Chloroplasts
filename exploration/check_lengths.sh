#!/bin/bash

# script to check the lengths of sequences in a fasta file
# usage: bash check_lengths.sh inputFile
# usage: bash check_lengths.sh /Users/bamflappy/GBCF/JRS/chloroplast/Juglanschlorosaln.fmt.fa

# retrieve input file
inputFile=$1

# set output file name
outputFile=$(dirname $inputFile)
outputFile=$outputFile"/genome_lengths.csv"

# count line lengths for every even line (sequences)
# add reformat line for downstream analysis
awk 'NR % 2 {print} !(NR % 2) { print length }' $inputFile | sed "s/$/,/g" | paste -d" " - - | sed "s/,$//g" | sed "s/ /-_/g"  > $outputFile
