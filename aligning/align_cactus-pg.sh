#!/bin/bash
#$ -M ebrooks5@nd.edu
#$ -m abe
#$ -r n
#$ -N align_cactus-pg_jobOutput
#$ -q largemem

# script to run cactus
# usage: qsub align_cactus-pg.sh analysisType
# usage ex: qsub align_cactus-pg.sh all
## job 846238
# usage ex: qsub align_cactus-pg.sh subset
## job 846240
# usage ex: qsub align_cactus-pg.sh LSC
## job 
# usage ex: qsub align_cactus-pg.sh IRa
## job 
# usage ex: qsub align_cactus-pg.sh SSC
## job 
# usage ex: qsub align_cactus-pg.sh IRb
## job 

# retrieve analysis type
analysisType=$1

# setup outputs name
outputsName="chloroplasts_pg_"$analysisType

# retrieve software path
softEnv=$(grep "cactus_env:" ../"inputs/software_HPC.txt" | tr -d " " | sed "s/cactus_env://g")

# retrieve inputs
inputsPath=$(grep "cactus_pangenome_"$analysisType":" ../"inputs/inputs_HPC.txt" | tr -d " " | sed "s/cactus_pangenome\_$analysisType\://g")

# retrieve inputs
inputRef=$(grep "cactus_ref:" ../"inputs/inputs_HPC.txt" | tr -d " " | sed "s/cactus_ref://g")

# retrieve analysis outputs absolute path
outputsPath=$(grep "outputs:" ../"inputs/inputs_HPC.txt" | tr -d " " | sed "s/outputs://g")

# make a new directory for analysis
alignOut=$outputsPath"/aligned_cactus-pg_"$analysisType
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
