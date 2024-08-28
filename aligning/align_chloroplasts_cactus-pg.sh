#!/bin/bash
#$ -M ebrooks5@nd.edu
#$ -m abe
#$ -r n
#$ -N align_chloroplasts_cactus-pg_jobOutput

# script to run cactus
# usage: qsub align_chloroplasts_cactus-pg.sh

# retrieve software path
softEnv=$(grep "cactus_env:" ../"inputs/software_HPC.txt" | tr -d " " | sed "s/cactus_env://g")

# retrieve inputs
inputsPath=$(grep "cactus_tree:" ../"inputs/inputs_HPC.txt" | tr -d " " | sed "s/cactus_tree://g")

# retrieve inputs
inputRef=$(grep "cactus_ref:" ../"inputs/inputs_HPC.txt" | tr -d " " | sed "s/cactus_ref://g")

# retrieve analysis outputs absolute path
outputsPath=$(grep "outputs:" ../"inputs/inputs_HPC.txt" | tr -d " " | sed "s/outputs://g")

# make a new directory for analysis
alignOut=$outputsPath"/aligned_cactus-pg"
mkdir $alignOut
#Check if the folder already exists
if [ $? -ne 0 ]; then
	echo "The $outFolder directory already exsists... please remove before proceeding."
	exit 1
fi

# move to the new directory
cd $alignOut

# activate python environment
source $softEnv

# status message
echo "Beginning analysis..."

# To run:
cactus-pangenome $alignOut"/js" $inputsPath --outDir "chloroplasts-pg" --outName "chloroplasts-pg" --reference $inputRef --vcf --giraffe --gfa --gbz --binariesMode singularity

# status message
echo "Analysis complete!"