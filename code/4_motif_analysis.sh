# Purpose: Perform motif analysis on cell-type specific enhancers to identify enriched transcription factor binding sites

WORKDIR=""
cd $WORKDIR
module load gcc/8.2.0 bedtools/2.30.0 homer/4.10.3

GENOME="hg38.fa"

sort -k5,5gr k562_specific_enhancers.bed | \
    head -n 1000 > top1000_k562_enhancers.bed

bedtools getfasta -fi ${GENOME} \
    -bed top1000_k562_enhancers.bed \
    -fo top1000_k562_enhancers.fasta

sort -k5,5gr gm12878_specific_enhancers.bed | \
    head -n 1000 > top1000_gm12878_enhancers.bed

bedtools getfasta -fi ${GENOME} \
    -bed top1000_gm12878_enhancers.bed \
    -fo top1000_gm12878_enhancers.fasta

findMotifs.pl top1000_k562_enhancers.fasta fasta \
    k562_enriched_motifs \
    -fasta top1000_gm12878_enhancers.fasta

findMotifs.pl top1000_gm12878_enhancers.fasta fasta \
    gm12878_enriched_motifs \
    -fasta top1000_k562_enhancers.fasta
