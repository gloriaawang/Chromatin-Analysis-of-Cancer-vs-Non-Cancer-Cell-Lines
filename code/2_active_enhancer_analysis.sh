#!/bin/bash

# 2_active_enhancer_analysis.sh
# Purpose: Identify active enhancers using H3K27ac ChIP-seq data
# and create visualization data

# Set working directory
WORKDIR=""
cd $WORKDIR

# Load required modules
module load gcc/8.2.0 bedtools/2.30.0 macs/2.2.7.1 deeptools/3.3.0

# Define input files
CHR_SIZES="hg38_chr_sizes.txt"
CHIP_BAM="k562_k27ac_chip.bam"
INPUT_BAM="k562_input.bam"

# Call H3K27ac peaks
echo "Calling H3K27ac peaks..."
macs2 callpeak -t ${CHIP_BAM} \
    -c ${INPUT_BAM} \
    --format BAM --name k562_k27ac \
    --gsize 2.9e9 --broad

# Extend peak boundaries by 100bp
echo "Extending peak boundaries..."
bedtools slop -i k562_k27ac_peaks.broadPeak \
    -g ${CHR_SIZES} -b 100 \
    > k562_k27ac_extended_peaks.bed

# Identify active enhancers
echo "Identifying active enhancers..."
bedtools intersect -a k562_enh.bed \
    -b k562_k27ac_extended_peaks.bed -u > k562_active_enh.bed

# Create inactive enhancer set for comparison
bedtools intersect -a k562_enh.bed \
    -b k562_k27ac_extended_peaks.bed -v > k562_inactive_enh.bed

# Create subsets for visualization
head -n 500 k562_active_enh.bed > k562_active_enh_500subset.bed
head -n 500 k562_inactive_enh.bed > k562_inactive_enh_500subset.bed

# Generate bigWig file for visualization
bamCoverage -b ${CHIP_BAM} \
    --normalizeUsing RPKM \
    --skipNonCoveredRegions \
    -o k562_k27ac.bw
