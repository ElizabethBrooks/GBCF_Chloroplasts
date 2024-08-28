#!/bin/bash
#$ -M ebrooks5@nd.edu
#$ -m abe
#$ -r n
#$ -N hal2maf_chloroplasts_cactus_jobOutput

# script to run cactus
# usage: qsub hal2maf_chloroplasts_cactus.sh
## job 

# retrieve software path
softEnv=$(grep "cactus_env:" ../"inputs/software_HPC.txt" | tr -d " " | sed "s/cactus_env://g")

# retrieve software environment
softPath=$(grep "cactus:" ../"inputs/software_HPC.txt" | tr -d " " | sed "s/cactus://g")

# retrieve inputs
inputsPath=$(grep "cactus_ref:" ../"inputs/inputs_HPC.txt" | tr -d " " | sed "s/cactus_ref://g")

# retrieve analysis outputs absolute path
outputsPath=$(grep "outputs:" ../"inputs/inputs_HPC.txt" | tr -d " " | sed "s/outputs://g")

# make a new directory for analysis
alignOut=$outputsPath"/aligned_cactus"

# move to the new directory
cd $alignOut

# activate python environment
source $softEnv

# status message
echo "Beginning analysis..."

# To run:
cactus-hal2maf $alignOut"/js" $alignOut"/aligned_chloroplasts.hal" $alignOut"/aligned_chloroplasts.maf.gz" --refGenome $inputsPath --chunkSize 500000 --binariesMode singularity 

# status message
echo "Analysis complete!"
