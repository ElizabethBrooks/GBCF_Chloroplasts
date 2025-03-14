#!/bin/bash

# script to get the pre defined chloroplast sequence regions
# We need to split each genome into four parts using single copy genes 
# and ensuring that the IRb and IRa regions are not identical
# usage: bash get_regions.sh sampleID
# usage ex: bash get_regions.sh Jailantifolia_136
# usageEx: for i in /Users/bamflappy/GBCF/JRS/chloroplast/formatted/chloroplast_genomes_renamed/*.fa; do species=$(basename $i | cut -d"." -f1); bash get_regions.sh $species; done

# retrieve input sample ID
sampleID="$1"

# set inputs directory names
regionsDir="/Users/bamflappy/GBCF/JRS/chloroplast/filtered"
genomesDir="/Users/bamflappy/GBCF/JRS/chloroplast/formatted/chloroplast_genomes_renamed"

# set output directory name
outputDir="/Users/bamflappy/GBCF/JRS/chloroplast/filtered/chloroplast_regions_renamed"

# create outputs directories
#mkdir $outputDir
# create outputs directories
#mkdir $outputDir"/region01_LSC"
#mkdir $outputDir"/region02_IRa"
#mkdir $outputDir"/region03_SSC"
#mkdir $outputDir"/region04_IRb"

# status message
echo "Beginning analysis..."

# retrieve region posititons
start_LSC=1
start_rps19=$(cat $regionsDir"/regions/region01_LSC.txt" | grep $sampleID"\t" | grep "rps19_" | cut -f2)
end_rps19=$(cat $regionsDir"/regions/region01_LSC.txt" | grep $sampleID"\t" | grep "rps19_" | cut -f3)
start_ndhF=$(cat $regionsDir"/regions/region03_SSC.txt" | grep $sampleID"\t" | grep "ndhF_" | cut -f2)
end_ndhF=$(cat $regionsDir"/regions/region03_SSC.txt" | grep $sampleID"\t" | grep "ndhF_" | cut -f3)
start_ndhA=$(cat $regionsDir"/regions/region03_SSC.txt" | grep $sampleID"\t" | grep "ndhA_" | cut -f2)
end_ndhA=$(cat $regionsDir"/regions/region03_SSC.txt" | grep $sampleID"\t" | grep "ndhA_" | cut -f3)
end_IRb=$(cat $genomesDir"/"$sampleID".fa" | grep -v ">" | sed "s/\n//g" | wc -c | cut -d"/" -f1 | tr -d " ")
end_IRb=$(($end_IRb-1))

# LSC: From psbA through rps19 (complete LSC section)
echo "Processing LSC for sample "$sampleID" ..."
# setup the region bed file
echo -e "chloroplast\t$start_LSC\t$end_rps19" > $outputDir"/region01_LSC/"$sampleID".bed"
# retrieve the region
bedtools getfasta -fi $genomesDir"/"$sampleID".fa" -bed $outputDir"/region01_LSC/"$sampleID".bed" -fo $outputDir"/region01_LSC/"$sampleID".fa.tmp"
# update header
cat $outputDir"/region01_LSC/"$sampleID".fa.tmp" | sed "s/^>.*/>LSC/g" > $outputDir"/region01_LSC/"$sampleID".fa"
# clean up
rm $outputDir"/region01_LSC/"$sampleID".bed"
rm $outputDir"/region01_LSC/"$sampleID".fa.tmp"

# check for inversions
# check if the end_ndhA is greater than the start_ndhF
if [[ $start_ndhA -gt $start_ndhF ]]; then
	# IRa: From rps19 through ndhF (IRa + neighboring SSC and LSC regions)
	echo "Processing IRa for sample "$sampleID" ..."
	# setup the region bed file
	echo -e "chloroplast\t$start_rps19\t$end_ndhF" > $outputDir"/region02_IRa/"$sampleID".bed"
	# retrieve the region
	bedtools getfasta -fi $genomesDir"/"$sampleID".fa" -bed $outputDir"/region02_IRa/"$sampleID".bed" -fo $outputDir"/region02_IRa/"$sampleID".fa.tmp"
	# update header
	cat $outputDir"/region02_IRa/"$sampleID".fa.tmp" | sed "s/^>.*/>IRa/g" > $outputDir"/region02_IRa/"$sampleID".fa"
	# clean up
	rm $outputDir"/region02_IRa/"$sampleID".bed"
	rm $outputDir"/region02_IRa/"$sampleID".fa.tmp"

	# SSC: From ndhF through ndhA (complete SSC section)
	echo "Processing SSC for sample "$sampleID" ..."
	# setup the region bed file
	echo -e "chloroplast\t$start_ndhF\t$end_ndhA" > $outputDir"/region03_SSC/"$sampleID".bed"
	# retrieve the region
	bedtools getfasta -fi $genomesDir"/"$sampleID".fa" -bed $outputDir"/region03_SSC/"$sampleID".bed" -fo $outputDir"/region03_SSC/"$sampleID".fa.tmp"
	# update header
	cat $outputDir"/region03_SSC/"$sampleID".fa.tmp" | sed "s/^>.*/>SSC/g" > $outputDir"/region03_SSC/"$sampleID".fa"
	# clean up
	rm $outputDir"/region03_SSC/"$sampleID".bed"
	rm $outputDir"/region03_SSC/"$sampleID".fa.tmp"

	# IRb: From ndhA through rpl2 (IRb + neighboring SSC region)
	echo "Processing IRb for sample "$sampleID" ..."
	# setup the region bed file
	echo -e "chloroplast\t$start_ndhA\t$end_IRb" > $outputDir"/region04_IRb/"$sampleID".bed"
	# retrieve the region
	bedtools getfasta -fi $genomesDir"/"$sampleID".fa" -bed $outputDir"/region04_IRb/"$sampleID".bed" -fo $outputDir"/region04_IRb/"$sampleID".fa.tmp"
	# update header
	cat $outputDir"/region04_IRb/"$sampleID".fa.tmp" | sed "s/^>.*/>IRb/g" > $outputDir"/region04_IRb/"$sampleID".fa"
	# clean up
	rm $outputDir"/region04_IRb/"$sampleID".bed"
	rm $outputDir"/region04_IRb/"$sampleID".fa.tmp"
else
	# IRa: From rps19 through ndhF (IRa + neighboring SSC and LSC regions)
	echo "Processing IRb for sample "$sampleID" ..."
	# setup the region and gene bed files
	echo -e "chloroplast\t$start_rps19\t$end_ndhA" > $outputDir"/region04_IRb/"$sampleID".bed"
	# retrieve the region and gene
	bedtools getfasta -fi $genomesDir"/"$sampleID".fa" -bed $outputDir"/region04_IRb/"$sampleID".bed" -fo $outputDir"/region04_IRb/"$sampleID".fa.tmp"
	# update header
	cat $outputDir"/region04_IRb/"$sampleID".fa.tmp" | sed "s/^>.*/>IRa/g" > $outputDir"/region04_IRb/"$sampleID".fa"
	# clean up
	rm $outputDir"/region04_IRb/"$sampleID".bed"
	rm $outputDir"/region04_IRb/"$sampleID".fa.tmp"

	# status message
	echo "Retrieving inversed SSC for sample "$sampleID" ..."
	#echo "Creating reverse complement of SSC_"$sampleID" ..."
	# swap the start and end for the region bed file
	echo -e "chloroplast\t$start_ndhA\t$end_ndhF" > $outputDir"/region03_SSC/"$sampleID".bed"
	# retrieve the region
	#bedtools getfasta -fi $genomesDir"/"*"_"$sampleID".fa" -bed $outputDir"/region03_SSC/"$sampleID".bed" -fo $outputDir"/region03_SSC/"$sampleID".fa.tmp"
	bedtools getfasta -fi $genomesDir"/"$sampleID".fa" -bed $outputDir"/region03_SSC/"$sampleID".bed" -fo $outputDir"/region03_SSC/"$sampleID".fa.tmp"
	# reverse complement the region
	#cat $outputDir"/region03_SSC/"$sampleID".fa.tmp" | tr ACGTacgt TGCAtgca | rev > $outputDir"/region03_SSC/"$sampleID".fa"
	# update header
	cat $outputDir"/region03_SSC/"$sampleID".fa.tmp" | sed "s/^>.*/>SSC/g" > $outputDir"/region03_SSC/"$sampleID".fa"
	# clean up
	rm $outputDir"/region03_SSC/"$sampleID".bed"
	rm $outputDir"/region03_SSC/"$sampleID".fa.tmp"

	# IRb: From ndhA through rpl2 (IRb + neighboring SSC region)
	echo "Processing IRa for sample "$sampleID" ..."
	# setup the region bed file
	echo -e "chloroplast\t$start_ndhF\t$end_IRb" > $outputDir"/region02_IRa/"$sampleID".bed"
	# retrieve the region
	bedtools getfasta -fi $genomesDir"/"$sampleID".fa" -bed $outputDir"/region02_IRa/"$sampleID".bed" -fo $outputDir"/region02_IRa/"$sampleID".fa.tmp"
	# update header
	cat $outputDir"/region02_IRa/"$sampleID".fa.tmp" | sed "s/^>.*/>IRb/g" > $outputDir"/region02_IRa/"$sampleID".fa"
	# clean up
	rm $outputDir"/region02_IRa/"$sampleID".bed"
	rm $outputDir"/region02_IRa/"$sampleID".fa.tmp"
fi

# status message
echo "Analysis complete!"
