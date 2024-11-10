#!/bin/bash

# script to use blastp to search to build blast files for MCScanX 
# https://www-nature-com.proxy.library.nd.edu/articles/s41596-024-00968-2
# https://github.com/wyp1125/MCScanX?tab=readme-ov-file
# usage: bash search_MCScanX_pipeline.sh queryTag dbTag
# usage ex: bash search_MCScanX_pipeline.sh Jcinerea_138 Jailantifolia_136
# usage ex: bash search_MCScanX_pipeline.sh Jcinerea_140 Jailantifolia_136
# usage ex: bash search_MCScanX_pipeline.sh JcinereaNB_142 Jailantifolia_136
# usage ex: bash search_MCScanX_pipeline.sh JcinereaNB_144 Jailantifolia_136
# usage ex: bash search_MCScanX_pipeline.sh JcinereaNB_145 Jailantifolia_136

# retrieve inputs
queryTag=$1
dbTag=$2

# retrieve software location
softLoc=$(grep "mcscanx:" ../inputs/inputs_local.txt | tr -d " " | sed "s/mcscanx://g")

# retrieve inputs and outputs directory path
outputDir=$(grep "outputs:" ../inputs/inputs_local.txt | tr -d " " | sed "s/outputs://g")

# setup inputs directory
inputsDir=$outputDir"/features_gffread"

# retrieve chloroplast annotations
chloroAnnot=$(grep "annotationsChloroplasts:" ../inputs/inputs_local.txt | tr -d " " | sed "s/annotationsChloroplasts://g")

# setup inputs paths
queryFileIn=$inputsDir"/"$queryTag"_proteins.fa"
dbFileIn=$inputsDir"/"$dbTag"_proteins.fa"
queryFileFeat=$(ls $chloroAnnot"/"*$queryTag"_"*"GFF3.gff3")
dbFileFeat=$(ls $chloroAnnot"/"*$dbTag"_"*"GFF3.gff3")

# setup outputs directory
outputFolder=$outputDir"/synteny_MCScanX"

# make output directory
mkdir $outputFolder

# setup outputs subdirectory
outputFolder=$outputFolder"/"$queryTag"_"$dbTag

# make output subdirectory
mkdir $outputFolder
# check if the folder already exists
if [ $? -ne 0 ]; then
	echo "The $outputFolder directory already exsists... please remove before proceeding."
	exit 1
fi

# setup MCScanX inputs directory
dataFolder=$outputFolder"/data"

# make output subdirectory
mkdir $dataFolder

# set cleaned input file names
queryFile=$queryFileIn".cleaned.fa"
dbFile=$dbFileIn".cleaned.fa"

# clean up input files and remove hyphens for blastp
# CFastaReader: Hyphens are invalid and will be ignored
cat $queryFileIn | sed "s/^.*gene=/>/g" | sed "s/^.*gene=/>$queryTag\_/g" > $queryFile
cat $dbFileIn | sed "s/^.*gene=/>/g" | sed "s/^.*gene=/>$dbTag\_/g" > $dbFile

# move to the scripts directory
cd scripts

# get currect directory path
scriptsDir=$(pwd)

# status message
echo "Beginning analysis..."

# 13. In the ‘intermediateData’ folder (from Step 11), concatenate the .gff file of all species into a ‘master.gff’ file
# copy the cleaned gff files for each species
cp $queryFileFeat $outputFolder"/"$queryTag".gff"
cp $dbFileFeat $outputFolder"/"$dbTag".gff"
# combine the gff files for MCScanX
cat $outputFolder"/"*.gff > $outputFolder"/"$queryTag"_"$dbTag"_master.gff"

# status message
echo "Creating blastable databases..."

# 15. Build the BLASTP database and place it in the ‘ncbiDB’ folder
# make the first blast able database
bash makeDB_blast.sh $dbFile $outputFolder"/"dbTag"_db" "prot"

# make the second blast able database
bash makeDB_blast.sh $queryFile $outputFolder"/"queryTag"_db" "prot"

# status message
echo "Running BLAST..."

# 16. Execute all-against-all BLASTP running all the desired pairwise genomes with an E-value cutoff of 1 × 10−10 and the best five non-self-hits reported in each target genome.
bash search_blast.sh $queryFile $outputFolder"/"dbTag"_db" $outputFolder $outputFolder"/"$dbTag"_"$queryTag".blast" 5 "blastp"

# 17. For each pair of genomes, switch the query and target genomes for a second execution.
bash search_blast.sh $dbFile $outputFolder"/"$queryTag"_db" $outputFolder $outputFolder"/"$queryTag"_"$dbTag".blast" 5 "blastp"

# 18. Because colinear genes may exist in the same genomes, perform within a genome all-against-all BLASTP for each genome, with the best six hits being kept.
bash search_blast.sh $dbFile $outputFolder"/"$dbTag"_db" $outputFolder $outputFolder"/"$dbTag"_"$dbTag".blast" 6 "blastp"

# perform second within genome all-against-all BLASTP search
bash search_blast.sh $queryFile $outputFolder"/"$queryTag"_db" $outputFolder $outputFolder"/"$queryTag"_"$queryTag".blast" 6 "blastp"

# 20. Concatenate the .blast files to generate a single ‘master.blast’ file
bash combineResults_blastp.sh $outputFolder $outputFolder"/"$dbTag"_"$queryTag"_master.blast"

# copy and re-name the inputs for MCScanX to the data folder
cp $outputFolder"/"$dbTag"_"$queryFile"_master.gff" $dataFolder"/master.gff"
cp $outputFolder"/"$dbTag"_"$queryFile"_master.blast" $dataFolder"/master.blast"

# move to software location
cd $softLoc

# status message
echo "Running MCScanX..."

# create MCScanX files for downstream analysis
./MCScanX $dataFolder"/master"

# move to downstream analysis directory
#cd downstream_analyses

# setup MCScanX outputs directory
#dataFolder=$outputFolder"/data"

# TO-DO: auto update inputs
# setup inputs
#circleCntl="/Users/bamflappy/Repos/GBCF_Chloroplasts/inputs/inputs_circle.ctl"
#dualCntl="/Users/bamflappy/Repos/GBCF_Chloroplasts/inputs/inputs_dual_synteny.ctl"
#dotCntl="/Users/bamflappy/Repos/GBCF_Chloroplasts/inputs/inputs_dot.ctl"

# status message
#echo "Creating circle plot..."

# create a circle plot
#java circle_plotter -g $dataFolder"/master.gff" -s $dataFolder"/master.collinearity" -c $circleCntl -o $dataFolder"/circle.png"

# status message
#echo "Creating dual synteny plot..."

# create dual synteny plots
#java dual_synteny_plotter -g $dataFolder"/master.gff" -s $dataFolder"/master.collinearity" -c $dualCntl -o $dataFolder"/dual_synteny.png"

# status message
#echo "Creating dot plot..."

# create dot plots
#java dot_plotter -g $dataFolder"/master.gff" -s $dataFolder"/master.collinearity" -c $dotCntl -o $dataFolder"/dot.png"

# status message
echo "Analysis complete!"
