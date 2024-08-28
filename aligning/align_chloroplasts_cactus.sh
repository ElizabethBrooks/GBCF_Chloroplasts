#!/bin/bash
#$ -M ebrooks5@nd.edu
#$ -m abe
#$ -r n
#$ -N align_chloroplasts_cactus_jobOutput

# script to run cactus
# usage: qsub align_chloroplasts_cactus.sh
## job 767536
## job

# retrieve software path
softEnv=$(grep "cactus_env:" ../"inputs/software_HPC.txt" | tr -d " " | sed "s/cactus_env://g")

# retrieve inputs
inputsPath=$(grep "cactus_tree:" ../"inputs/inputs_HPC.txt" | tr -d " " | sed "s/cactus_tree://g")

# retrieve analysis outputs absolute path
outputsPath=$(grep "outputs:" ../"inputs/inputs_HPC.txt" | tr -d " " | sed "s/outputs://g")

# make a new directory for analysis
alignOut=$outputsPath"/aligned_cactus"
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
cactus $alignOut"/js" $inputsPath $alignOut"/aligned_chloroplasts.hal" --binariesMode singularity 

# status message
echo "Analysis complete!"
