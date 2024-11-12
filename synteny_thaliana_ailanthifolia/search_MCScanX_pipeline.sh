#!/bin/bash

# script to use blastp to search to build a blast file for MCScanX 
# https://www-nature-com.proxy.library.nd.edu/articles/s41596-024-00968-2
# https://github.com/wyp1125/MCScanX?tab=readme-ov-file
# usage: bash search_MCScanX_pipeline.sh

# retrieve inputs
queryFileIn=$(grep "ailanthifoliaPep:" ../inputs/inputs_local.txt | tr -d " " | sed "s/ailanthifoliaPep://g")
dbFileIn=$(grep "thalianaPep:" ../inputs/inputs_local.txt | tr -d " " | sed "s/thalianaPep://g")
queryFileFeat=$(grep "ailanthifoliaFeat:" ../inputs/inputs_local.txt | tr -d " " | sed "s/ailanthifoliaFeat://g")
dbFileFeat=$(grep "thalianaFeat:" ../inputs/inputs_local.txt | tr -d " " | sed "s/thalianaFeat://g")

# retrieve software location
softLoc=$(grep "mcscanx:" ../inputs/inputs_local.txt | tr -d " " | sed "s/mcscanx://g")

# setup outputs directory
outputFolder=$(grep "outputs:" ../inputs/inputs_local.txt | tr -d " " | sed "s/outputs://g")
outputFolder=$outputFolder"/synteny_MCScanX"

# make output directory
mkdir $outputFolder

# setup outputs subdirectory
outputFolder=$outputFolder"/thaliana_ailanthifolia"

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
cat $queryFileIn | sed "s/^.*gene=/>/g" | sed "s/] \[locus_tag.*$/_jaC/g" > $queryFile
cat $dbFileIn | sed "s/^.*gene=/>/g" | sed "s/] \[locus_tag.*$/_atC/g" > $dbFile

# move to the scripts directory
cd scripts

# get currect directory path
scriptsDir=$(pwd)

# status message
echo "Beginning analysis..."

# 13. In the ‘intermediateData’ folder (from Step 11), concatenate the .gff file of all species into a ‘master.gff’ file
# copy the cleaned gff files for each species
cp $queryFileFeat $outputFolder"/ailanthifolia.gff"
cp $dbFileFeat $outputFolder"/thaliana.gff"
# combine the gff files for MCScanX
cat $outputFolder"/"*.gff > $outputFolder"/thaliana_ailanthifolia_master.gff"

# status message
echo "Creating blastable databases..."

# 15. Build the BLASTP database and place it in the ‘ncbiDB’ folder
# make the first blast able database
bash makeDB_blast.sh $dbFile $outputFolder"/thaliana_db" "prot"

# make the second blast able database
bash makeDB_blast.sh $queryFile $outputFolder"/ailanthifolia_db" "prot"

# status message
echo "Running BLAST..."

# 16. Execute all-against-all BLASTP running all the desired pairwise genomes with an E-value cutoff of 1 × 10−10 and the best five non-self-hits reported in each target genome.
bash search_blast.sh $queryFile $outputFolder"/thaliana_db" $outputFolder $outputFolder"/thaliana_ailanthifolia.blast" 5 "blastp"

# 17. For each pair of genomes, switch the query and target genomes for a second execution.
bash search_blast.sh $dbFile $outputFolder"/ailanthifolia_db" $outputFolder $outputFolder"/ailanthifolia_thaliana.blast" 5 "blastp"

# 18. Because colinear genes may exist in the same genomes, perform within a genome all-against-all BLASTP for each genome, with the best six hits being kept.
bash search_blast.sh $dbFile $outputFolder"/thaliana_db" $outputFolder $outputFolder"/thaliana_thaliana.blast" 6 "blastp"

# perform second within genome all-against-all BLASTP search
bash search_blast.sh $queryFile $outputFolder"/ailanthifolia_db" $outputFolder $outputFolder"/ailanthifolia_ailanthifolia.blast" 6 "blastp"

# 20. Concatenate the .blast files to generate a single ‘master.blast’ file
bash combineResults_blastp.sh $outputFolder $outputFolder"/thaliana_ailanthifolia_master.blast"

# copy and re-name the inputs for MCScanX to the data folder
cp $outputFolder"/thaliana_ailanthifolia_master.gff" $dataFolder"/master.gff"
cp $outputFolder"/thaliana_ailanthifolia_master.blast" $dataFolder"/master.blast"

# move to software location
cd $softLoc

# status message
echo "Running MCScanX..."

# create MCScanX files for downstream analysis
./MCScanX  $dataFolder"/master"

# move to downstream analysis directory
cd downstream_analyses

# setup MCScanX outputs directory
dataFolder=$outputFolder"/data"

# setup inputs
circleCntl="/Users/bamflappy/Repos/GBCF_Chloroplasts/inputs/inputs_circle.ctl"
dualCntl="/Users/bamflappy/Repos/GBCF_Chloroplasts/inputs/inputs_dual_synteny.ctl"
dotCntl="/Users/bamflappy/Repos/GBCF_Chloroplasts/inputs/inputs_dot.ctl"

# TO-DO: double check order of species
# update input control files with species tags
cat $circleCntl | sed "s/speciesOne/atC/g" | sed "s/speciesTwo/jaC/g" > $dataFolder"/inputs_circle.ctl"
cat $dualCntl | sed "s/speciesOne/atC/g" | sed "s/speciesTwo/jaC/g" > $dataFolder"/inputs_dual_synteny.ctl"
cat $dotCntl | sed "s/speciesOne/atC/g" | sed "s/speciesTwo/jaC/g" > $dataFolder"/inputs_dot.ctl"

# status message
echo "Creating circle plot..."

# create a circle plot
java circle_plotter -g $dataFolder"/master.gff" -s $dataFolder"/master.collinearity" -c $dataFolder"/inputs_circle.ctl" -o $dataFolder"/circle.png"

# status message
echo "Creating dual synteny plot..."

# create dual synteny plots
java dual_synteny_plotter -g $dataFolder"/master.gff" -s $dataFolder"/master.collinearity" -c $dataFolder"/inputs_dual_synteny.ctl" -o $dataFolder"/dual_synteny.png"

# status message
echo "Creating dot plot..."

# create dot plots
java dot_plotter -g $dataFolder"/master.gff" -s $dataFolder"/master.collinearity" -c $dataFolder"/inputs_dot.ctl" -o $dataFolder"/dot.png"

# status message
echo "Analysis complete!"
