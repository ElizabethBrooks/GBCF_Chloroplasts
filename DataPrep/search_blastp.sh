#!/bin/bash
#$ -M ebrooks5@nd.edu
#$ -m abe
#$ -r n
#$ -N search_blastp_jobOutput
#$ -pe smp 4

# script to use blastp to search to build a blast file for MCScanX 
# https://www-nature-com.proxy.library.nd.edu/articles/s41596-024-00968-2
# https://github.com/wyp1125/MCScanX?tab=readme-ov-file
# usage: qsub search_blastp.sh

#Load necessary modules for ND CRC servers
module load bio/2.0

# retrieve inputs
queryFile=$(grep "ailanthifolia:" ../InputData/inputs_HPC.txt | tr -d " " | sed "s/ailanthifolia://g")
dbFile=$(grep "arabadopsis:" ../InputData/inputs_HPC.txt | tr -d " " | sed "s/arabadopsis://g")

# setup outputs directory
outputFolder=$(grep "outputs:" ../InputData/inputs_HPC.txt | tr -d " " | sed "s/outputs://g")
outputFolder=$outputFolder"/orthology_MCScanX"

#Make output directory
mkdir $outputFolder
#Check if the folder already exists
if [ $? -ne 0 ]; then
	echo "The $outputFolder directory already exsists... please remove before proceeding."
	exit 1
fi

#Move to output folder
cd "$outputFolder"

# status message
echo "Building blast able database..."

# make the blast able database
#./makeblastdb -in ncbi/species1.fa -out ncbiDB/species1 -dbtype prot
makeblastdb -in $dbFile -out $outputFolder -dbtype prot

# status message
echo "Beginning blastp search..."

# Execute all-against-all BLASTP running all the desired pairwise genomes with an E-value cutoff of 1 × 10−10 and the best five non-self-hits reported in each target genome
#blastp -db ncbiDB/species1 -query ncbi/species2.fa -evalue 1e-10 -num_alignments 5 -outfmt 6 -out intermediateData/species1-2.blast
blastp -query $queryFile -db $dbFile -outfmt 6 -evalue 1e-10 -num_alignments 5 -out $outputFolder"/arabadopsis-ailanthifolia.blast" -num_threads 4

# status message
echo "Finished blastp search!"
