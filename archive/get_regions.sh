#!/bin/bash

# script to get the pre defined chloroplast sequence regions
# We need to split each genome into four parts using single copy genes 
# and ensuring that the IRb and IRa regions are not identical
# usage: bash get_regions.sh sampleID
# usage ex: bash get_regions.sh 136
# usageEx: for i in /Users/bamflappy/GBCF/JRS/chloroplast/formatted/chloroplast_genomes_renamed/*.fa; do species=$(basename $i | cut -d"_" -f2 | cut -d"." -f1); bash get_regions.sh $species; done

# retrieve input sample ID
sampleID="$1"

# set input directory name
inputDir="/Users/bamflappy/GBCF/JRS/chloroplast"

# set output directory name
outputDir="/Users/bamflappy/GBCF/JRS/chloroplast/filtered/regions"

# create outputs directory
#mkdir $outputDir

# status message
echo "Beginning analysis..."

# retrieve region posititons
start_LSC=1
start_rps19=$(cat $inputDir"/regions/region01.txt" | grep "_"$sampleID"\t" | grep "rps19_" | cut -f2)
end_rps19=$(cat $inputDir"/regions/region01.txt" | grep "_"$sampleID"\t" | grep "rps19_" | cut -f3)
start_ndhF=$(cat $inputDir"/regions/region03.txt" | grep "_"$sampleID"\t" | grep "ndhF_" | cut -f2)
end_ndhF=$(cat $inputDir"/regions/region03.txt" | grep "_"$sampleID"\t" | grep "ndhF_" | cut -f3)
start_ndhA=$(cat $inputDir"/regions/region03.txt" | grep "_"$sampleID"\t" | grep "ndhA_" | cut -f2)
end_ndhA=$(cat $inputDir"/regions/region03.txt" | grep "_"$sampleID"\t" | grep "ndhA_" | cut -f3)
end_IRb=$(cat $inputDir"/formatted/chloroplast_genomes_renamed/"*"_"$sampleID".fa" | grep -v ">" | sed "s/\n//g" | wc -c | cut -d"/" -f1 | tr -d " ")
end_IRb=$(($end_IRb-1))

# LSC: From psbA through rps19 (complete LSC section)
echo "Processing region01 for sample "$sampleID" ..."
# setup the region bed file
echo -e "chloroplast\t$start_LSC\t$end_rps19" > $outputDir"/region01_"$sampleID".bed"
# retrieve the region
bedtools getfasta -fi $inputDir"/formatted/chloroplast_genomes_renamed/"*"_"$sampleID".fa" -bed $outputDir"/region01_"$sampleID".bed" -fo $outputDir"/region01_"$sampleID".fa.tmp"
# update header
cat $outputDir"/region01_"$sampleID".fa.tmp" | sed "s/^>.*/>chloroplast_region01/g" > $outputDir"/region01_"$sampleID".fa.out"
# clean up
rm $outputDir"/region01_"$sampleID".bed"
rm $outputDir"/region01_"$sampleID".fa.tmp"

# check for inversions
# check if the end_ndhA is greater than the start_ndhF
if [[ $start_ndhA -gt $start_ndhF ]]; then
	# IRa: From rps19 through ndhF (IRa + neighboring SSC and LSC regions)
	echo "Processing region02 for sample "$sampleID" ..."
	# setup the region bed file
	echo -e "chloroplast\t$start_rps19\t$end_ndhF" > $outputDir"/region02_"$sampleID".bed"
	# retrieve the region
	bedtools getfasta -fi $inputDir"/formatted/chloroplast_genomes_renamed/"*"_"$sampleID".fa" -bed $outputDir"/region02_"$sampleID".bed" -fo $outputDir"/region02_"$sampleID".fa.tmp"
	# update header
	cat $outputDir"/region02_"$sampleID".fa.tmp" | sed "s/^>.*/>chloroplast_region02/g" > $outputDir"/region02_"$sampleID".fa.out"
	# clean up
	rm $outputDir"/region02_"$sampleID".bed"
	rm $outputDir"/region02_"$sampleID".fa.tmp"

	# SSC: From ndhF through ndhA (complete SSC section)
	echo "Processing region03 for sample "$sampleID" ..."
	# setup the region bed file
	echo -e "chloroplast\t$start_ndhF\t$end_ndhA" > $outputDir"/region03_"$sampleID".bed"
	# retrieve the region
	bedtools getfasta -fi $inputDir"/formatted/chloroplast_genomes_renamed/"*"_"$sampleID".fa" -bed $outputDir"/region03_"$sampleID".bed" -fo $outputDir"/region03_"$sampleID".fa.tmp"
	# update header
	cat $outputDir"/region03_"$sampleID".fa.tmp" | sed "s/^>.*/>chloroplast_region03/g" > $outputDir"/region03_"$sampleID".fa.out"
	# clean up
	rm $outputDir"/region03_"$sampleID".bed"
	rm $outputDir"/region03_"$sampleID".fa.tmp"

	# IRb: From ndhA through rpl2 (IRb + neighboring SSC region)
	echo "Processing region04 for sample "$sampleID" ..."
	# setup the region bed file
	echo -e "chloroplast\t$start_ndhA\t$end_IRb" > $outputDir"/region04_"$sampleID".bed"
	# retrieve the region
	bedtools getfasta -fi $inputDir"/formatted/chloroplast_genomes_renamed/"*"_"$sampleID".fa" -bed $outputDir"/region04_"$sampleID".bed" -fo $outputDir"/region04_"$sampleID".fa.tmp"
	# update header
	cat $outputDir"/region04_"$sampleID".fa.tmp" | sed "s/^>.*/>chloroplast_region04/g" > $outputDir"/region04_"$sampleID".fa.out"
	# clean up
	rm $outputDir"/region04_"$sampleID".bed"
	rm $outputDir"/region04_"$sampleID".fa.tmp"
else
	# IRa: From rps19 through ndhF (IRa + neighboring SSC and LSC regions)
	echo "Processing region02 for sample "$sampleID" ..."
	# setup the region and gene bed files
	echo -e "chloroplast\t$start_rps19\t$start_ndhA" > $outputDir"/region02_part_"$sampleID".bed"
	echo -e "chloroplast\t$start_ndhF\t$end_ndhF" > $outputDir"/region02_ndhF_"$sampleID".bed"
	# retrieve the region and gene
	bedtools getfasta -fi $inputDir"/formatted/chloroplast_genomes_renamed/"*"_"$sampleID".fa" -bed $outputDir"/region02_part_"$sampleID".bed" -fo $outputDir"/region02_part_"$sampleID".fa.out"
	bedtools getfasta -fi $inputDir"/formatted/chloroplast_genomes_renamed/"*"_"$sampleID".fa" -bed $outputDir"/region02_ndhF_"$sampleID".bed" -fo $outputDir"/region02_ndhF_"$sampleID".fa.out"
	# update header and combine the region and gene sequnces
	cat $outputDir"/region02_part_"$sampleID".fa.out" | sed "s/^>.*/>chloroplast_region02/g" | tr -d "\n" | sed "s/>chloroplast_region02/>chloroplast_region02\n/g" > $outputDir"/region02_"$sampleID".fa.out"
	tail -n+2 $outputDir"/region02_ndhF_"$sampleID".fa.out" >> $outputDir"/region02_"$sampleID".fa.out"
	# clean up
	rm $outputDir"/region02_part_"$sampleID".bed"
	rm $outputDir"/region02_ndhF_"$sampleID".bed"
	rm $outputDir"/region02_part_"$sampleID".fa.out"
	rm $outputDir"/region02_ndhF_"$sampleID".fa.out"

	# status message
	echo "Retrieving inversed region03 for sample "$sampleID" ..."
	#echo "Creating reverse complement of region03_"$sampleID" ..."
	# swap the start and end for the region bed file
	echo -e "chloroplast\t$start_ndhA\t$end_ndhF" > $outputDir"/region03_"$sampleID".bed"
	# retrieve the region
	#bedtools getfasta -fi $inputDir"/formatted/chloroplast_genomes_renamed/"*"_"$sampleID".fa" -bed $outputDir"/region03_"$sampleID".bed" -fo $outputDir"/region03_"$sampleID".fa.tmp"
	bedtools getfasta -fi $inputDir"/formatted/chloroplast_genomes_renamed/"*"_"$sampleID".fa" -bed $outputDir"/region03_"$sampleID".bed" -fo $outputDir"/region03_"$sampleID".fa.tmp"
	# reverse complement the region
	#cat $outputDir"/region03_"$sampleID".fa.tmp" | tr ACGTacgt TGCAtgca | rev > $outputDir"/region03_"$sampleID".fa.out"
	# update header
	cat $outputDir"/region03_"$sampleID".fa.tmp" | sed "s/^>.*/>chloroplast_region03/g" > $outputDir"/region03_"$sampleID".fa.out"
	# clean up
	rm $outputDir"/region03_"$sampleID".bed"
	rm $outputDir"/region03_"$sampleID".fa.tmp"

	# IRb: From ndhA through rpl2 (IRb + neighboring SSC region)
	echo "Processing region04 for sample "$sampleID" ..."
	# setup the region bed file
	echo -e "chloroplast\t$end_ndhF\t$end_IRb" > $outputDir"/region04_part_"$sampleID".bed"
	echo -e "chloroplast\t$start_ndhA\t$end_ndhA" > $outputDir"/region04_ndhA_"$sampleID".bed"
	# retrieve the region
	bedtools getfasta -fi $inputDir"/formatted/chloroplast_genomes_renamed/"*"_"$sampleID".fa" -bed $outputDir"/region04_part_"$sampleID".bed" -fo $outputDir"/region04_part_"$sampleID".fa.out"
	bedtools getfasta -fi $inputDir"/formatted/chloroplast_genomes_renamed/"*"_"$sampleID".fa" -bed $outputDir"/region04_ndhA_"$sampleID".bed" -fo $outputDir"/region04_ndhA_"$sampleID".fa.out"
	# update header and combine the region and gene sequnces
	cat $outputDir"/region04_ndhA_"$sampleID".fa.out" | sed "s/^>.*/>chloroplast_region04/g" | tr -d "\n" | sed "s/>chloroplast_region04/>chloroplast_region04\n/g" > $outputDir"/region04_"$sampleID".fa.out"
	tail -n+2 $outputDir"/region04_part_"$sampleID".fa.out" >> $outputDir"/region04_"$sampleID".fa.out"
	# clean up
	rm $outputDir"/region04_part_"$sampleID".bed"
	rm $outputDir"/region04_ndhA_"$sampleID".bed"
	rm $outputDir"/region04_part_"$sampleID".fa.out"
	rm $outputDir"/region04_ndhA_"$sampleID".fa.out"
fi

# status message
echo "Analysis complete!"
