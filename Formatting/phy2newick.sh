#!/bin/bash

# script to subset and rename genome sequences
# usage: bash phy2newick.sh

# convert phy to newick using FastTree
FastTree -nt "/Users/bamflappy/GBCF/JRS/chloroplast/aligned_cactus-pg_subset/cactus_output_multiline.phy" > "/Users/bamflappy/GBCF/JRS/chloroplast/aligned_cactus-pg_subset/cactus_tree_renamed.newick"
