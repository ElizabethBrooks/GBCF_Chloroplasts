#!/bin/bash

# script to install and test run cactus

# Note that the following workflow for cactus works on the ND remote servers scratch365 space, but not home currently.

# About: 
# https://www.nature.com/articles/s41586-020-2871-y

# Installation: 
# https://github.com/ComparativeGenomicsToolkit/cactus

# Cactus requires Python >= 3.7 along with Python development headers and libraries

# Clone cactus and submodules:
git clone https://github.com/ComparativeGenomicsToolkit/cactus.git --recursive

# Create the Python virtual environment. Install virtualenv first if needed with:
python3 -m pip install virtualenv

# Then:
cd cactus
virtualenv -p python3 cactus_env
echo "export PATH=$(pwd)/bin:\$PATH" >> cactus_env/bin/activate
echo "export PYTHONPATH=$(pwd)/lib:\$PYTHONPATH" >> cactus_env/bin/activate
source cactus_env/bin/activate
python3 -m pip install -U setuptools pip wheel
python3 -m pip install -U .
python3 -m pip install -U -r ./toil-requirement.txt

# On Slurm: https://github.com/ComparativeGenomicsToolkit/cactus/blob/master/doc/progressive.md

# "You cannot run cactus --batchSystem slurm from inside the Cactus docker container, because the Cactus docker container doesn't 
# contain slurm. Therefore in order to use slurm, you must be able to pip install Cactus inside a virtualenv on the head node. You 
# can still use --binariesMode docker or --binariesMode singularity to run cactus binaries from a container, but the Cactus Python 
# module needs to be installed locally."

# To run:
cactus ./js ./examples/evolverMammals.txt ./evolverMammals.hal --binariesMode singularity 

# Use the --restart flag for subsequent runs:
cactus ./js ./examples/evolverMammals.txt ./evolverMammals.hal --binariesMode singularity --restart

# To run step-by-step:
cactus-prepare examples/evolverMammals.txt --outDir steps-output --outSeqFile steps-output/evovlerMammals.txt --outHal steps-output/evolverMammals.hal --jobStore jobstore
