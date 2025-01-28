### Installation

<b>First,</b> download this GitHub repository using the git clone command in the terminal as follows.

To download the code onto a local computer or server space, click the green <i>< > Code</i> button and copy the link. Then, using the HTTPS web URL in the terminal:

git clone https://github.com/ElizabethBrooks/GBCF_Chloroplasts.git

Alternatively, using SSH:

git clone git@github.com:ElizabethBrooks/GBCF_Chloroplasts.git

The latest version of this application may also be downloaded from this repository by clicking the green <i>< > Code</i> button near the top of the page, and then clicking <i>Download ZIP</i>.

### Analysis Workflow

1. Filter by length and identify longest sequence for potential reference. Also, plot the distribution sequence lengths
2. Format input sequences and create input files for MCScanX
3. Investigate longest sequence gene content and order using [MCScanX](https://github.com/wyp1125/MCScanX) and the NCBI reference [Arabadopsis thaliana](https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_000001735.4/) chloroplast genome assembly (see "annotations" directory). The CHLOROBOX GeSeq online tool and Cufflinks gffread was used to annotate the chloroplast sequences and create the necessary gff and protein sequences files for the MCScanX synteny analysis.
4. Fix orientation of sequences contained in the inverted repeat regions and format longest sequences for downstream analysis
5. Create an inputs file for cactus that has the names and file paths to sequences
6. Create alignments using [cactus-pangenome](https://github.com/ComparativeGenomicsToolkit/cactus/blob/master/doc/pangenome.md) and convert the hal files using cactus-hal2maf
7. Evalute alignments with tube maps using [sequenceTubeMap](https://vgteam.github.io/sequenceTubeMap/) and the cactus output vg file in the "chrom_alignments" sub-directory
8. Convert the maf file to phy using the maf2phy.py script, then convert the phy to newick using the phy2newick.sh script with FastTree. Also, visualize the newlick files using TreeDyn from https://www.phylogeny.fr/ and Tree Viewer from http://etetoolkit.org/treeview/
