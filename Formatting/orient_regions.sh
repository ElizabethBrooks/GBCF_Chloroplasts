#!/bin/bash

# script to get the pre defined chloroplast sequence regions
# We need to split each genome into four parts using single copy genes 
# and ensuring that the IRb and IRa regions are not identical
# usage: bash orient_regions.sh sampleID
# usage ex: bash orient_regions.sh Jailantifolia_136
# usageEx: for i in /Users/bamflappy/GBCF/JRS/chloroplast/formatted/chloroplast_genomes_renamed/*.fa; do species=$(basename $i | cut -d"." -f1); bash orient_regions.sh $species; done

# retrieve input sample ID
sampleID="$1"

# set inputs directory names
regionsDir="/Users/bamflappy/GBCF/JRS/chloroplast/filtered/regions"
genomesDir="/Users/bamflappy/GBCF/JRS/chloroplast/formatted/chloroplast_genomes_renamed"

# set output directory name
outputDir="/Users/bamflappy/GBCF/JRS/chloroplast/formatted/chloroplast_oriented"

# create outputs directory
#mkdir $outputDir

# status message
echo "Beginning analysis..."

# retrieve region posititons
start_ndhF=$(cat $regionsDir"/region03_SSC.txt" | grep $sampleID"\t" | grep "ndhF_" | cut -f2)
start_ndhA=$(cat $regionsDir"/region03_SSC.txt" | grep $sampleID"\t" | grep "ndhA_" | cut -f2)

# check for inversions
# check if the end_ndhA is greater than the start_ndhF
if [[ $start_ndhA -lt $start_ndhF ]]; then
	# status message
	echo "Reverse complementing $sampleID ..."
	# retrieve header
	cat $genomesDir"/"$sampleID".fa" | head -1 > $outputDir"/"$sampleID".fa"
	# reverse complement sequence
	cat $genomesDir"/"$sampleID".fa" | tail -n+2 | tr ACGTacgt TGCAtgca | rev >> $outputDir"/"$sampleID".fa"
else
	# status message
	echo "Copying $sampleID ..."
	# copy file
	cat $genomesDir"/"$sampleID".fa" > $outputDir"/"$sampleID".fa"
fi

# status message
echo "Analysis complete!"
