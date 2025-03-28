#!/bin/bash

# script to find the pre defined chloroplast sequence regions
# We need to split each genome into four parts using single copy genes 
# and ensuring that the IRb and IRa regions are not identical
# usage: bash find_regions.sh

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
rm $outputDir"/region0"*".txt"

# LSC: From psbA through rps19 (complete LSC section - starting with nt 1)
for i in $inputDir"/"*.gff; do sampleID=$(basename $i | cut -d"_" -f1,2); cat $i | grep "psbA_" | sed "s/^/$sampleID\t/g" >> $outputDir"/region01_LSC.txt"; done
for i in $inputDir"/"*.gff; do sampleID=$(basename $i | cut -d"_" -f1,2); cat $i | grep "rps19_" | sed "s/^/$sampleID\t/g" >> $outputDir"/region01_LSC.txt"; done

# IRa: From rps19 through ndhF (IRa + neighboring SSC and LSC regions)
# reverse complement positions: From rps19 through ndhA
for i in $inputDir"/"*.gff; do sampleID=$(basename $i | cut -d"_" -f1,2); cat $i | grep "rps19_" | sed "s/^/$sampleID\t/g" >> $outputDir"/region02_IRa.txt"; done
for i in $inputDir"/"*.gff; do sampleID=$(basename $i | cut -d"_" -f1,2); cat $i | grep "ndhF_" | sed "s/^/$sampleID\t/g" >> $outputDir"/region02_IRa.txt"; done

# SSC: From ndhF through ndhA (complete SSC section)
# reverse complement positions: From ndhA through ndhF
for i in $inputDir"/"*.gff; do sampleID=$(basename $i | cut -d"_" -f1,2); cat $i | grep "ndhF_" | sed "s/^/$sampleID\t/g" >> $outputDir"/region03_SSC.txt"; done
for i in $inputDir"/"*.gff; do sampleID=$(basename $i | cut -d"_" -f1,2); cat $i | grep "ndhA_" | sed "s/^/$sampleID\t/g" >> $outputDir"/region03_SSC.txt"; done

# IRb: From ndhA through rpl2 (IRb + neighboring SSC region - to the last nt)
# reverse complement positions: From ndhF through rpl2
for i in $inputDir"/"*.gff; do sampleID=$(basename $i | cut -d"_" -f1,2); cat $i | grep "ndhA_" | sed "s/^/$sampleID\t/g" >> $outputDir"/region04_IRb.txt"; done
for i in $inputDir"/"*.gff; do sampleID=$(basename $i | cut -d"_" -f1,2); cat $i | grep "rpl2_" | sort -k4 -n -r | sed "s/^/$sampleID\t/g" >> $outputDir"/region04_IRb.txt"; done
