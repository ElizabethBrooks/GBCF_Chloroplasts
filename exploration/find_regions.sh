#!/bin/bash

# script to find the pre defined chloroplast sequence regions
# We need to split each genome into four parts using single copy genes 
# and ensuring that the IRb and IRa regions are not identical
# usage: bash find_regions.sh

# set input directory name
inputDir="/Users/bamflappy/GBCF/JRS/chloroplast/JRS_CHLOROBOX/formatted"

# set output directory name
outputDir="/Users/bamflappy/GBCF/JRS/chloroplast/regions"

# pre clean up
rm -r $outputDir

# create outputs directory
mkdir $outputDir

# LSC: From psbA through rps19 (complete LSC section - starting with nt 1)
for i in $inputDir"/"*chloroplast_genes.gff; do cat $i | grep "psbA_" | head -1 | cut -f 2-4 >> $outputDir"/region01.txt"; done
for i in $inputDir"/"*chloroplast_genes.gff; do cat $i | grep "rps19_" | head -1 | cut -f 2-4 >> $outputDir"/region01.txt"; done

# IRa: From rps19 through ndhF (IRa + neighboring SSC and LSC regions)
# reverse complement positions: From rps19 through ndhA
for i in $inputDir"/"*chloroplast_genes.gff; do cat $i | grep "rps19_" | head -1 | cut -f 2-4 >> $outputDir"/region02.txt"; done
for i in $inputDir"/"*chloroplast_genes.gff; do cat $i | grep "ndhF_" | head -1 | cut -f 2-4 >> $outputDir"/region02.txt"; done

# SSC: From ndhF through ndhA (complete SSC section)
# reverse complement positions: From ndhA through ndhF
for i in $inputDir"/"*chloroplast_genes.gff; do cat $i | grep "ndhF_" | head -1 | cut -f 2-4 >> $outputDir"/region03.txt"; done
for i in $inputDir"/"*chloroplast_genes.gff; do cat $i | grep "ndhA_" | head -1 | cut -f 2-4 >> $outputDir"/region03.txt"; done

# IRb: From ndhA through rpl2 (IRb + neighboring SSC region - to the last nt)
# reverse complement positions: From ndhF through rpl2
for i in $inputDir"/"*chloroplast_genes.gff; do cat $i | grep "ndhA_" | head -1 | cut -f 2-4 >> $outputDir"/region04.txt"; done
for i in $inputDir"/"*chloroplast_genes.gff; do cat $i | grep "rpl2_" | sort -k4 -n -r | cut -f 2-4 | head -1 >> $outputDir"/region04.txt"; done
