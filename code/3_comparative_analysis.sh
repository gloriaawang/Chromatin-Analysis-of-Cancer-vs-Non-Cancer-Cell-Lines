#!/bin/bash

# 3_comparative_analysis.sh
# Purpose: Compare enhancers between K562 and GM12878 cell lines
# and prepare visualization data

# Set working directory
WORKDIR="/ihome/biosc1542_2024s/glw30/mp2"
cd $WORKDIR

# Load required modules
module load gcc/8.2.0 bedtools/2.30.0

# Define input files
CHR_SIZES="/ix1/biosc1542_2024s/data/hg38_chr_sizes.txt"
GM12878_ENH="/ix1/biosc1542_2024s/mp2/gm12878_active_enh.bed"

# Create 101bp windows for fair comparison
echo "Creating 101bp windows around K562 enhancers..."
bedtools slop -i k562_active_enh.bed \
    -g ${CHR_SIZES} -b 50 \
    > k562_active_enh_101bp.bed

# Find shared enhancers
echo "Identifying shared enhancers..."
bedtools intersect -a k562_active_enh_101bp.bed \
    -b ${GM12878_ENH} -u \
    > shared_k562_gm12878_enhancers.bed

# Find K562-specific enhancers
echo "Identifying K562-specific enhancers..."
bedtools intersect -a k562_active_enh_101bp.bed \
    -b ${GM12878_ENH} -v \
    > k562_specific_enhancers.bed

# Find GM12878-specific enhancers
echo "Identifying GM12878-specific enhancers..."
bedtools intersect -a ${GM12878_ENH} \
    -b k562_active_enh_101bp.bed -v \
    > gm12878_specific_enhancers.bed

# Create visualization subsets
head -n 500 shared_k562_gm12878_enhancers.bed > shared_500.bed
head -n 500 k562_specific_enhancers.bed > k562_specific_500.bed
head -n 500 gm12878_specific_enhancers.bed > gm12878_specific_500.bed

# Print statistics
echo "Enhancer overlap statistics:"
wc -l k562_specific_enhancers.bed
wc -l gm12878_specific_enhancers.bed
wc -l shared_k562_gm12878_enhancers.bed
