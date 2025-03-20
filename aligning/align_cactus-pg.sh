#!/bin/bash
#$ -M ebrooks5@nd.edu
#$ -m abe
#$ -r n
#$ -N align_cactus-pg_jobOutput
#$ -q largemem

# script to run cactus
# usage: qsub align_cactus-pg.sh regionInput analysisType
# regions (non-inverted IRa and IRb for problematic samples)
# usage ex: qsub align_cactus-pg.sh LSC regions
## job 1507460
# usage ex: qsub align_cactus-pg.sh IRa regions
## job 1507461
# usage ex: qsub align_cactus-pg.sh SSC regions
## job 1507462
# usage ex: qsub align_cactus-pg.sh IRb regions
## job 1507463
# inverted (inverted IRa and IRb for problematic samples)
# usage ex: qsub align_cactus-pg.sh LSC regions_inverted
## job 
# usage ex: qsub align_cactus-pg.sh IRa regions_inverted
## job 
# usage ex: qsub align_cactus-pg.sh SSC regions_inverted
## job 
# usage ex: qsub align_cactus-pg.sh IRb regions_inverted
## job 

# retrieve region inputs
regionInput=$1

# retrieve analysis type
analysisType=$2

# setup outputs name
outputsName="chloroplasts_pg_"$regionInput

# retrieve software path
softEnv=$(grep "cactus_env:" ../"inputs/software_HPC.txt" | tr -d " " | sed "s/cactus_env://g")

# retrieve inputs
inputsPath=$(grep $regionInput":" ../"inputs/inputs_"$analysisType".txt" | tr -d " " | sed "s/$regionInput\://g")

# retrieve inputs
inputRef=$(grep "cactus_ref:" ../"inputs/inputs_HPC.txt" | tr -d " " | sed "s/cactus_ref://g")

# retrieve analysis outputs absolute path
outputsPath=$(grep "outputs:" ../"inputs/inputs_HPC.txt" | tr -d " " | sed "s/outputs://g")

# make a new directory for analysis
alignOut=$outputsPath"/aligned_"$regionInput"_"$analysisType
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
cactus-pangenome $alignOut"/js" $inputsPath --outDir $outputsName --outName $outputsName --reference $inputRef --vcf --giraffe --gfa --gbz --binariesMode singularity

# status message
echo "Analysis complete!"
