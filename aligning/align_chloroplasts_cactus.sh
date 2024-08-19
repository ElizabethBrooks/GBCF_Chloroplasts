#!/bin/bash
#$ -M ebrooks5@nd.edu
#$ -m abe
#$ -r n
#$ -N align_chloroplasts_cactus_jobOutput

# script to run cactus
# usage: qsub align_chloroplasts_cactus.sh

# retrieve software path
softEnv=$(grep "cactus_env:" ../"inputs/software_HPC.txt" | tr -d " " | sed "s/cactus_env://g")

# retrieve software environment
softPath=$(grep "cactus:" ../"inputs/software_HPC.txt" | tr -d " " | sed "s/cactus://g")

# retrieve inputs
inputsPath=$(grep "cactus:" ../"inputs/inputs_HPC.txt" | tr -d " " | sed "s/cactus://g")

# retrieve analysis outputs absolute path
outputsPath=$(grep "outputs:" ../"inputs/inputs_HPC.txt" | tr -d " " | sed "s/outputs://g")

# make a new directory for analysis
alignOut=$outputsPath"/aligned_cactus"
mkdir $alignOut

# move to the new directory
cd $alignOut

# activate python environment
source $softEnv

# status message
echo "Beginning analysis..."

# To run:
cactus $alignOut"/js" $inputsPath $alignOut"/aligned_test.hal" --binariesMode singularity 

# status message
echo "Analysis complete!"
