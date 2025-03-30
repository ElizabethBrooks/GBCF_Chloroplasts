#!/bin/bash

# script to use blastp to search to build blast files for MCScanX 
# https://www-nature-com.proxy.library.nd.edu/articles/s41596-024-00968-2
# https://github.com/wyp1125/MCScanX?tab=readme-ov-file
# usage: bash search_MCScanX_pipeline.sh queryTag dbTag
# usage ex: bash search_MCScanX_pipeline.sh Jcathayensis_135 Jailantifolia_136
# usage ex: # usage ex: for i in /Users/bamflappy/GBCF/JRS/chloroplast/JRS_CHLOROBOX/*GFF3.gff3; do species=$(basename $i | sed "s/JRS_chloro_long_//g" | sed "s/_GFF3.gff3//g"); bash search_MCScanX_pipeline.sh $species Jailantifolia_136; done

# retrieve inputs
queryTag="JcinereaNB_144"
dbTag="Jailantifolia_136"
#queryTag=$1
#dbTag=$2

# retrieve software location
softLoc=$(grep "mcscanx:" ../inputs/inputs_local.txt | tr -d " " | sed "s/mcscanx://g")

# retrieve inputs and outputs directory path
outputDir="/Users/bamflappy/GBCF/JRS/chloroplast"
#outputDir=$(grep "outputs:" ../inputs/inputs_local.txt | tr -d " " | sed "s/outputs://g")

# setup inputs directory
inputsDir=$outputDir
#inputsDir=$outputDir"/features_gffread"

# retrieve chloroplast annotations
#chloroAnnot=$(grep "annotationsChloroplasts:" ../inputs/inputs_local.txt | tr -d " " | sed "s/annotationsChloroplasts://g")

# setup inputs paths
queryFileIn="/Users/bamflappy/GBCF/JRS/chloroplast/annotations/chloroplast_144/Jailantifolia_144_proteins.fa"
dbFileIn="/Users/bamflappy/GBCF/JRS/chloroplast/annotations/chloroplast_136/Jailantifolia_136_proteins.fa"
queryFileFeat="/Users/bamflappy/GBCF/JRS/chloroplast/annotations/chloroplast_144/formatted_blatX_hits/JcinereaNB_144_chloroplast_genes.gff"
dbFileFeat="/Users/bamflappy/GBCF/JRS/chloroplast/annotations/chloroplast_136/formatted_blatX_hits/Jailantifolia_136_chloroplast_genes.gff"
#queryFileIn=$inputsDir"/"$queryTag"_proteins.fa"
#dbFileIn=$inputsDir"/"$dbTag"_proteins.fa"
#queryFileFeat=$chloroAnnot"/formatted/"$queryTag"_chloroplast_genes.gff"
#dbFileFeat=$chloroAnnot"/formatted/"$dbTag"_chloroplast_genes.gff"

# TO-DO: fix formatting of feature files

# setup outputs directory
outputFolder=$outputDir"/synteny_MCScanX_"$queryTag"_"$dbTag
#outputFolder=$outputDir"/synteny_MCScanX"

# make output directory
#mkdir $outputFolder

# setup outputs subdirectory
#outputFolder=$outputFolder"/"$queryTag"_"$dbTag

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
cat $queryFileIn | sed "s/^.*gene=/>/g" | sed "s/^.*gene=/>/g" | awk -v speciesTag=$queryTag '{if (/^>/) {$0=$0 "_"speciesTag}; print}' | tr '.' '*' > $queryFile
cat $dbFileIn | sed "s/^.*gene=/>/g" | sed "s/^.*gene=/>/g" | awk -v speciesTag=$dbTag '{if (/^>/) {$0=$0 "_"speciesTag}; print}'  | tr '.' '*' > $dbFile

# move to the scripts directory
cd scripts

# get currect directory path
scriptsDir=$(pwd)

# status message
echo "Beginning analysis..."

# 13. In the ‘intermediateData’ folder (from Step 11), concatenate the .gff file of all species into a ‘master.gff’ file
# copy the formatted gff files for each species
cp $queryFileFeat $outputFolder"/"$queryTag".gff"
cp $dbFileFeat $outputFolder"/"$dbTag".gff"
# combine the gff files for MCScanX
cat $outputFolder"/"*.gff > $outputFolder"/"$queryTag"_"$dbTag"_master.gff"

# status message
echo "Creating blastable databases..."

# 15. Build the BLASTP database and place it in the ‘ncbiDB’ folder
# make the first blast able database
bash makeDB_blast.sh $dbFile $outputFolder"/"$dbTag"_db" "prot"

# make the second blast able database
bash makeDB_blast.sh $queryFile $outputFolder"/"$queryTag"_db" "prot"

# status message
echo "Running BLAST..."

# 16. Execute all-against-all BLASTP running all the desired pairwise genomes with an E-value cutoff of 1 × 10−10 and the best five non-self-hits reported in each target genome.
bash search_blast.sh $queryFile $outputFolder"/"$dbTag"_db" $outputFolder $outputFolder"/"$dbTag"_"$queryTag".blast" 5 "blastp"

# 17. For each pair of genomes, switch the query and target genomes for a second execution.
bash search_blast.sh $dbFile $outputFolder"/"$queryTag"_db" $outputFolder $outputFolder"/"$queryTag"_"$dbTag".blast" 5 "blastp"

# 18. Because colinear genes may exist in the same genomes, perform within a genome all-against-all BLASTP for each genome, with the best six hits being kept.
bash search_blast.sh $dbFile $outputFolder"/"$dbTag"_db" $outputFolder $outputFolder"/"$dbTag"_"$dbTag".blast" 6 "blastp"

# perform second within genome all-against-all BLASTP search
bash search_blast.sh $queryFile $outputFolder"/"$queryTag"_db" $outputFolder $outputFolder"/"$queryTag"_"$queryTag".blast" 6 "blastp"

# 20. Concatenate the .blast files to generate a single ‘master.blast’ file
bash combineResults_blastp.sh $outputFolder $outputFolder"/"$queryTag"_"$dbTag"_master.blast"

# copy and re-name the inputs for MCScanX to the data folder
cp $outputFolder"/"$queryTag"_"$dbTag"_master.gff" $dataFolder"/master.gff"
cp $outputFolder"/"$queryTag"_"$dbTag"_master.blast" $dataFolder"/master.blast"

# move to software location
cd $softLoc

# status message
echo "Running MCScanX..."

# create MCScanX files for downstream analysis
./MCScanX $dataFolder"/master"

# move to downstream analysis directory
cd downstream_analyses

# setup MCScanX outputs directory
dataFolder=$outputFolder"/data"

# copy input control files
circleCntl="/Users/bamflappy/Repos/GBCF_Chloroplasts/inputs/inputs_circle.ctl"
dualCntl="/Users/bamflappy/Repos/GBCF_Chloroplasts/inputs/inputs_dual_synteny.ctl"
dotCntl="/Users/bamflappy/Repos/GBCF_Chloroplasts/inputs/inputs_dot.ctl"

# update input control files with species tags
cat $circleCntl | sed "s/speciesOne/$queryTag/g" | sed "s/speciesTwo/$dbTag/g" > $dataFolder"/inputs_circle.ctl"
cat $dualCntl | sed "s/speciesOne/$queryTag/g" | sed "s/speciesTwo/$dbTag/g" > $dataFolder"/inputs_dual_synteny.ctl"
cat $dotCntl | sed "s/speciesOne/$queryTag/g" | sed "s/speciesTwo/$dbTag/g" > $dataFolder"/inputs_dot.ctl"

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
