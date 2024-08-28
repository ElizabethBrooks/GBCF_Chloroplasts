# GBCF Bioinformatics Analysis Report

- Project: JRS Chloroplasts Analysis
- Contact: Jeanne Romero-Severson
- Analyst: Elizabeth Brooks
- Date: 28 August 2024

## Code

Click [here](https://github.com/ElizabethBrooks/GBCF_Chloroplasts) for the analysis code repository.

## Analysis Workflow Steps

1. Filter by length and identify longest sequence for potential reference
2. Format input sequences and create input files for MCScanX
3. Investigate longest sequence gene content and order using [MCScanX](https://github.com/wyp1125/MCScanX) and the NCBI reference [Arabadopsis thaliana](https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_000001735.4/) chloroplast genome assembly (see "annotations" directory)
4. Format longest sequences for downstream analysis
5. Create bifurcating tree using [MAFFT](https://mafft.cbrc.jp/)
6. Create inputs file for cactus that has the tree and file paths to sequences
7. Create alignments using [cactus-pangenome](https://github.com/ComparativeGenomicsToolkit/cactus/blob/master/doc/pangenome.md)
8. Evalute alignments with tube maps using [sequenceTubeMap](https://vgteam.github.io/sequenceTubeMap/) and the cactus output vg file in the "chrom_alignments" sub-directory

## Notes

### Step 1

We selected a potential reference genome (Juglan ailanthifolia) from the set of chloroplast sequences. Our first step was to filter the set of chloroplast sequences by length. Please see the plot showing the distribution of sequence lengths. There are 44 sequences that are 159,700 bases or longer. The remaining 121 sequences are 115,343 bases or shorter. The longest chloroplast sequence in our data set was from Juglans ailanthifolia with a length of 160,400 bases, which was the longest chloroplast sequence in the set. 

### Step 2

The protein sequences for the chloroplast genes of the potential longest reference genome (Juglan ailanthifolia) were retrieved from NCBI, after the chloroplast genome was put through BLAST and the associated assembly was identified. The name of the associated NCBI assembly matches the header of the potential longest reference genome. 

The headers for the input chloroplast gene protein seqeunces to MCScanX should be simple so that the resulting plots are clear and easy to read.

There needs to be a separate input file for each different type of plot that is created using MCScanX.

### Step 3

To make sure that known chloroplast genes are well represented, we compared the J. ailanthifolia chloroplast (jaC) sequence to the Arabidopsis thaliana chloroplast (atC) complete genome. Please see the dual synteny plot comparing the chloroplast genomes, which shows that the gene content and order between the chloroplast sequences is very similar.

There are two genes unique to A. thaliana (psbZ, psbB) and four genes unique to J. ailanthifolia (lhbA, psi, infA, ycf15). The psaB and psaA genes are tandem in both species. The protein sequence of the ndhD gene is very different between the species.

### Step 4

There needs to be separate fasta files for each genome (for cactus) with the same header for each chloroplast sequence (for sequenceTubeMap).

There needs to be a combined fasta file with all the chloroplast sequences (for MAFFT) with the file name for each genome as the sequence header (for cactus).

### Step 5

The input tree to cactus needs to be a bifurcating tree, which can be made by MAFFT using UPGMA rather than NJ methods.

### Step 8

Only a portion of the chloroplast sequences can be visualized, so this part of the analysis will need to be interactive.
