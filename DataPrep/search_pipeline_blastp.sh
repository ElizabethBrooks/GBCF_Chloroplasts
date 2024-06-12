#!/bin/bash

# script to use blastp to search to build a blast file for MCScanX 
# https://www-nature-com.proxy.library.nd.edu/articles/s41596-024-00968-2
# https://github.com/wyp1125/MCScanX?tab=readme-ov-file
# usage: bash search_pipeline_blastp.sh

# retrieve inputs
queryFile=$(grep "ailanthifolia:" ../InputData/inputs_HPC.txt | tr -d " " | sed "s/ailanthifolia://g")
#queryFile=$(grep "ailanthifolia:" ../InputData/inputs_local.txt | tr -d " " | sed "s/ailanthifolia://g")
dbFile=$(grep "arabadopsis:" ../InputData/inputs_HPC.txt | tr -d " " | sed "s/arabadopsis://g")
#dbFile=$(grep "arabadopsis:" ../InputData/inputs_local.txt | tr -d " " | sed "s/arabadopsis://g")

# setup outputs directory
outputFolder=$(grep "outputs:" ../InputData/inputs_HPC.txt | tr -d " " | sed "s/outputs://g")
#outputFolder=$(grep "outputs:" ../InputData/inputs_local.txt | tr -d " " | sed "s/outputs://g")
outputFolder=$outputFolder"/orthology_MCScanX"

# make output directory
mkdir $outputFolder

# setup outputs subdirectory
outputFolder=$outputFolder"/arabadopsis_ailanthifolia"

# make output subdirectory
mkdir $outputFolder
# check if the folder already exists
if [ $? -ne 0 ]; then
	echo "The $outputFolder directory already exsists... please remove before proceeding."
	exit 1
fi

# move to the scripts directory
cd ../scripts

# status message
echo "Beginning analysis..."

# make the first blast able database
bash makeDB_blastp.sh $dbFile $outputFolder"/arabadopsis_db"

# make the second blast able database
bash makeDB_blastp.sh $queryFile $outputFolder"/ailanthifolia_db"

# 16. Execute all-against-all BLASTP running all the desired pairwise genomes with an E-value cutoff of 1 × 10−10 and the best five non-self-hits reported in each target genome.
qsub searchBetween_blastp.sh $queryFile $outputFolder"/arabadopsis_db" $outputFolder $outputFolder"/arabadopsis_ailanthifolia.blast"

# 17. For each pair of genomes, switch the query and target genomes for a second execution.
qsub searchBetween_blastp.sh $dbFile $outputFolder"/ailanthifolia_db" $outputFolder $outputFolder"/ailanthifolia_arabadopsis.blast"

# 18. Because colinear genes may exist in the same genomes, perform within a genome all-against-all BLASTP for each genome, with the best six hits being kept.
qsub searchWithin_blastp.sh $dbFile $outputFolder"/arabadopsis_db" $outputFolder $outputFolder"/arabadopsis_arabadopsis.blast"

# perform second within genome all-against-all BLASTP search
qsub searchWithin_blastp.sh $queryFile $outputFolder"/ailanthifolia_db" $outputFolder $outputFolder"/ailanthifolia_ailanthifolia.blast"

# 20. Concatenate the .blast files to generate a single ‘master.blast’ file
#bash combineResults_blastp.sh $outputFolder $outputFolder"/arabadopsis_ailanthifolia_master.blast"

# status message
echo "Analysis complete!"
