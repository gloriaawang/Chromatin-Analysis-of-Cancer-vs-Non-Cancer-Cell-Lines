#!/bin/bash

# 4_motif_analysis.sh
# Purpose: Perform motif analysis on cell-type specific enhancers
# to identify enriched transcription factor binding sites

# Set working directory
WORKDIR=""
cd $WORKDIR

# Load required modules
module load gcc/8.2.0 bedtools/2.30.0 homer/4.10.3

# Define input files
GENOME="hg38.fa"

# Get top 1000 K562-specific enhancers by significance
echo "Selecting top K562-specific enhancers..."
sort -k5,5gr k562_specific_enhancers.bed | \
    head -n 1000 > top1000_k562_enhancers.bed

# Extract sequences for K562 enhancers
bedtools getfasta -fi ${GENOME} \
    -bed top1000_k562_enhancers.bed \
    -fo top1000_k562_enhancers.fasta

# Get top 1000 GM12878-specific enhancers
echo "Selecting top GM12878-specific enhancers..."
sort -k5,5gr gm12878_specific_enhancers.bed | \
    head -n 1000 > top1000_gm12878_enhancers.bed

# Extract sequences for GM12878 enhancers
bedtools getfasta -fi ${GENOME} \
    -bed top1000_gm12878_enhancers.bed \
    -fo top1000_gm12878_enhancers.fasta

# Run HOMER motif finding for K562-specific enhancers
echo "Running motif analysis on K562-specific enhancers..."
findMotifs.pl top1000_k562_enhancers.fasta fasta \
    k562_enriched_motifs \
    -fasta top1000_gm12878_enhancers.fasta

# Run HOMER motif finding for GM12878-specific enhancers
echo "Running motif analysis on GM12878-specific enhancers..."
findMotifs.pl top1000_gm12878_enhancers.fasta fasta \
    gm12878_enriched_motifs \
    -fasta top1000_k562_enhancers.fasta
