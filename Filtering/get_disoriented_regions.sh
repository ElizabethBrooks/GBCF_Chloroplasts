#!/bin/bash

# script to get the pre defined chloroplast sequence regions
# We need to split each genome into four parts using single copy genes 
# and ensuring that the IRb and IRa regions are not identical
# usage: bash get_disoriented_regions.sh sampleID
# usage ex: bash get_disoriented_regions.sh Jailantifolia_136
# usage ex: bash get_disoriented_regions.sh JcinereaNB_144
# usageEx: for i in /Users/bamflappy/GBCF/JRS/chloroplast/formatted/chloroplast_genomes_renamed/*.fa; do species=$(basename $i | cut -d"." -f1); bash get_disoriented_regions.sh $species; done

# retrieve input sample ID
sampleID="$1"

# set inputs directory names
regionsDir="/Users/bamflappy/GBCF/JRS/chloroplast/filtered"
genomesDir="/Users/bamflappy/GBCF/JRS/chloroplast/formatted/chloroplast_genomes_renamed"

# set output directory name
outputDir="/Users/bamflappy/GBCF/JRS/chloroplast/filtered/chloroplast_regions_renamed"

# create outputs directories
mkdir $outputDir
# create outputs directories
mkdir $outputDir"/region01_non_inverted"
mkdir $outputDir"/region02_inverted"
mkdir $outputDir"/region03_non_inverted"
mkdir $outputDir"/re_oriented"

# status message
echo "Beginning analysis..."

# retrieve region posititons
start_seq=0
start_ycf1_1=$(cat $regionsDir"/regions/inverted_region.txt" | grep $sampleID"\t" | grep "ycf1_1" | cut -f3)
end_ycf1_1=$(cat $regionsDir"/regions/inverted_region.txt" | grep $sampleID"\t" | grep "ycf1_1" | cut -f4)
start_ycf1_fragment_1=$(cat $regionsDir"/regions/inverted_region.txt" | grep $sampleID"\t" | grep "ycf1-fragment_1" | cut -f3)
end_ycf1_fragment_1=$(cat $regionsDir"/regions/inverted_region.txt" | grep $sampleID"\t" | grep "ycf1-fragment_1" | cut -f4)
end_seq=$(cat $genomesDir"/"$sampleID".fa" | grep -v ">" | sed "s/\n//g" | wc -c | cut -d"/" -f1 | tr -d " ")
end_seq=$(($end_seq-1))

# check for inversions
# check if the end_ndhA is greater than the start_ndhF
if [[ $start_ycf1_1 -lt $start_ycf1_fragment_1 ]]; then # does not contain an inversion
	# first non-inverted region
	echo "Processing first non-inverted region for sample "$sampleID" ..."
	# setup the region bed file
	echo -e "chloroplast\t$start_seq\t$start_ycf1_1" > $outputDir"/region01_non_inverted/"$sampleID".bed"
	# retrieve the region
	bedtools getfasta -fi $genomesDir"/"$sampleID".fa" -bed $outputDir"/region01_non_inverted/"$sampleID".bed" -fo $outputDir"/region01_non_inverted/"$sampleID".fa.tmp"
	# update header
	cat $outputDir"/region01_non_inverted/"$sampleID".fa.tmp" | sed "s/^>.*/>region01/g" > $outputDir"/region01_non_inverted/"$sampleID".fa"
	# clean up
	rm $outputDir"/region01_non_inverted/"$sampleID".bed"
	rm $outputDir"/region01_non_inverted/"$sampleID".fa.tmp"

	# inverted region
	echo "Processing inverted region for sample "$sampleID" ..."
	# setup the region bed file
	echo -e "chloroplast\t$start_ycf1_1\t$end_ycf1_fragment_1" > $outputDir"/region02_inverted/"$sampleID".bed"
	# retrieve the region
	bedtools getfasta -fi $genomesDir"/"$sampleID".fa" -bed $outputDir"/region02_inverted/"$sampleID".bed" -fo $outputDir"/region02_inverted/"$sampleID".fa.tmp"
	# update header
	cat $outputDir"/region02_inverted/"$sampleID".fa.tmp" | sed "s/^>.*/>region02/g" > $outputDir"/region02_inverted/"$sampleID".fa"
	# clean up
	rm $outputDir"/region02_inverted/"$sampleID".bed"
	rm $outputDir"/region02_inverted/"$sampleID".fa.tmp"

	# last non-inverted region
	echo "Processing last non-inverted region for sample "$sampleID" ..."
	# setup the region bed file
	echo -e "chloroplast\t$end_ycf1_fragment_1\t$end_seq" > $outputDir"/region03_non_inverted/"$sampleID".bed"
	# retrieve the region
	bedtools getfasta -fi $genomesDir"/"$sampleID".fa" -bed $outputDir"/region03_non_inverted/"$sampleID".bed" -fo $outputDir"/region03_non_inverted/"$sampleID".fa.tmp"
	# update header
	cat $outputDir"/region03_non_inverted/"$sampleID".fa.tmp" | sed "s/^>.*/>region03/g" > $outputDir"/region03_non_inverted/"$sampleID".fa"
	# clean up
	rm $outputDir"/region03_non_inverted/"$sampleID".bed"
	rm $outputDir"/region03_non_inverted/"$sampleID".fa.tmp"
else # contains inversion
	# first non-inverted region
	echo "Processing first non-inverted region for sample "$sampleID" ..."
	# setup the region bed file
	echo -e "chloroplast\t$start_seq\t$start_ycf1_fragment_1" > $outputDir"/region01_non_inverted/"$sampleID".bed"
	# retrieve the region
	bedtools getfasta -fi $genomesDir"/"$sampleID".fa" -bed $outputDir"/region01_non_inverted/"$sampleID".bed" -fo $outputDir"/region01_non_inverted/"$sampleID".fa.tmp"
	# update header
	cat $outputDir"/region01_non_inverted/"$sampleID".fa.tmp" | sed "s/^>.*/>region01/g" > $outputDir"/region01_non_inverted/"$sampleID".fa"
	# clean up
	rm $outputDir"/region01_non_inverted/"$sampleID".bed"
	rm $outputDir"/region01_non_inverted/"$sampleID".fa.tmp"

	# inverted region
	echo "Processing inverted region for sample "$sampleID" ..."
	# setup the region and gene bed files
	echo -e "chloroplast\t$start_ycf1_fragment_1\t$end_ycf1_1" > $outputDir"/region02_inverted/"$sampleID".bed"
	# retrieve the region and gene
	bedtools getfasta -fi $genomesDir"/"$sampleID".fa" -bed $outputDir"/region02_inverted/"$sampleID".bed" -fo $outputDir"/region02_inverted/"$sampleID".fa.tmp"
	# update header
	cat $outputDir"/region02_inverted/"$sampleID".fa.tmp" | head -1 | sed "s/^>.*/>region02/g" > $outputDir"/region02_inverted/"$sampleID".fa"
	cat $outputDir"/region02_inverted/"$sampleID".fa.tmp" | tail -n+2 | tr ACGTacgt TGCAtgca | rev >> $outputDir"/region02_inverted/"$sampleID".fa"
	# clean up
	rm $outputDir"/region02_inverted/"$sampleID".bed"
	rm $outputDir"/region02_inverted/"$sampleID".fa.tmp"


	# last non-inverted region
	echo "Processing last non-inverted region for sample "$sampleID" ..."
	# setup the region bed file
	echo -e "chloroplast\t$end_ycf1_1\t$end_seq" > $outputDir"/region03_non_inverted/"$sampleID".bed"
	# retrieve the region and gene
	bedtools getfasta -fi $genomesDir"/"$sampleID".fa" -bed $outputDir"/region03_non_inverted/"$sampleID".bed" -fo $outputDir"/region03_non_inverted/"$sampleID".fa.tmp"
	# update header
	cat $outputDir"/region03_non_inverted/"$sampleID".fa.tmp" | sed "s/^>.*/>region03/g" > $outputDir"/region03_non_inverted/"$sampleID".fa"
	# clean up
	rm $outputDir"/region03_non_inverted/"$sampleID".bed"
	rm $outputDir"/region03_non_inverted/"$sampleID".fa.tmp"
fi

# recombine all the regions
cat $outputDir"/region01_non_inverted/"$sampleID".fa" | head -1 | sed "s/^>.*/>chloroplast/g" > $outputDir"/re_oriented/"$sampleID".fa"
cat $outputDir"/region01_non_inverted/"$sampleID".fa" | tail -n+2 | tr -d "\n" >> $outputDir"/re_oriented/"$sampleID".fa"
cat $outputDir"/region02_inverted/"$sampleID".fa" | tail -n+2 | tr -d "\n" >> $outputDir"/re_oriented/"$sampleID".fa"
cat $outputDir"/region03_non_inverted/"$sampleID".fa" | tail -n+2 >> $outputDir"/re_oriented/"$sampleID".fa"

# status message
echo "Analysis complete!"
