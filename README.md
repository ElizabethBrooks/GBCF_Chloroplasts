# GBCF Bioinformatics Analysis Report

- Project: JRS Chloroplasts Analysis
- Contact: Jeanne Romero-Severson
- Analysts: Elizabeth Brooks & Sheri Sanders
- Date: 30 September 2024

## Code

Click [here](https://github.com/ElizabethBrooks/GBCF_Chloroplasts) for the analysis code repository.

## Analysis Workflow Steps

1. Filter by length and identify longest sequence for potential reference. Also, plot the distribution sequence lengths
2. Format input sequences and create input files for MCScanX
3. Investigate longest sequence gene content and order using [MCScanX](https://github.com/wyp1125/MCScanX) and the NCBI reference [Arabadopsis thaliana](https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_000001735.4/) chloroplast genome assembly (see "annotations" directory)
4. Format longest sequences for downstream analysis
5. Create an inputs file for cactus that has the names and file paths to sequences
6. Create alignments using [cactus-pangenome](https://github.com/ComparativeGenomicsToolkit/cactus/blob/master/doc/pangenome.md) and convert the hal files using cactus-hal2maf
7. Evalute alignments with tube maps using [sequenceTubeMap](https://vgteam.github.io/sequenceTubeMap/) and the cactus output vg file in the "chrom_alignments" sub-directory
8. Convert the maf file to phy using the maf2phy.py script, then convert the phy to newick using the phy2newick.sh script with FastTree. Also, visualize the newlick files using TreeDyn from https://www.phylogeny.fr/ and Tree Viewer from http://etetoolkit.org/treeview/

## Notes

### Step 1

Our first step was to filter the set of chloroplast sequences by length. Please see the plot showing the distribution of sequence lengths. 

There are 44 sequences that are 159,700 bases or longer. The remaining 121 sequences are 115,343 bases or shorter. 

The longest chloroplast sequence in our data set was from Juglans ailanthifolia with a length of 160,400 bases. 

### Step 2

The protein sequences for the chloroplast genes of the potential longest reference genome (Juglan ailanthifolia) were retrieved from NCBI, after the chloroplast genome was put through BLAST and the associated assembly was identified. The name of the associated NCBI assembly matches the header of the potential longest reference genome. 

The headers for the input chloroplast gene protein seqeunces to MCScanX should be simple so that the resulting plots are clear and easy to read.

Note that there needs to be a separate input file for each different type of plot that is created using MCScanX.

### Step 3

To make sure that known chloroplast genes are well represented, we compared the J. ailanthifolia chloroplast (jaC) sequence to the Arabidopsis thaliana chloroplast (atC) complete genome. Please see the dual synteny plot comparing the chloroplast genomes, which shows that the gene content and order between the chloroplast sequences is very similar.

There are two genes unique to A. thaliana (psbZ, psbB) and four genes unique to J. ailanthifolia (lhbA, psi, infA, ycf15). The psaB and psaA genes are tandem in both species. The protein sequence of the ndhD gene is very different between the species.

### Step 4

There needs to be separate fasta files for each genome (for cactus) with the same header for each chloroplast sequence (for sequenceTubeMap). 

The input sample cannot be prefixed by the given reference using a period (e.g., Jailantifolia.136). "This is not supported by this version of Cactus, so one of these samples needs to be renamed to continue." 

Additionally, the headers for the chloroplast sequences cannot be only numeric values, since this results in an error when running cactus-hal2maf.

### Step 7

Only a portion of the chloroplast sequences can be visualized, so this part of the analysis will need to be interactive.
