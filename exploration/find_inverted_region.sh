#!/bin/bash

# script to find inverted region in the problematic chloroplast genomes
# usage: bash find_inverted_region.sh

# set input directory name
inputDir="/Users/bamflappy/GBCF/JRS/chloroplast/JRS_CHLOROBOX/formatted_blatX_hits/formatted_locations"

# set output directory name
outputDir="/Users/bamflappy/GBCF/JRS/chloroplast/filtered"

# create outputs directory
mkdir $outputDir

# set output directory name
outputDir="/Users/bamflappy/GBCF/JRS/chloroplast/filtered/regions"

# create outputs directory
mkdir $outputDir

# pre clean up
rm $outputDir"/inverted_region.txt"

# LSC: From psbA through rps19 (complete LSC section - starting with nt 1)
#for i in $inputDir"/"*.gff; do sampleID=$(basename $i | cut -d"_" -f1,2); cat $i | grep "rps12_3" | sed "s/^/$sampleID\t/g" >> $outputDir"/inverted_region.txt"; done
for i in $inputDir"/"*.gff; do sampleID=$(basename $i | cut -d"_" -f1,2); cat $i | grep "ycf1_1" | sed "s/^/$sampleID\t/g" >> $outputDir"/inverted_region.txt"; done
for i in $inputDir"/"*.gff; do sampleID=$(basename $i | cut -d"_" -f1,2); cat $i | grep "ycf1-fragment_1" | sed "s/^/$sampleID\t/g" >> $outputDir"/inverted_region.txt"; done
#for i in $inputDir"/"*.gff; do sampleID=$(basename $i | cut -d"_" -f1,2); cat $i | grep "rps12_4" | sed "s/^/$sampleID\t/g" >> $outputDir"/inverted_region.txt"; done
