#!/bin/bash

# Purpose: Identify putative enhancers in K562 cells using ATAC-seq data by excluding regions that overlap with promoters

WORKDIR=""
cd $WORKDIR
module load gcc/8.2.0 bedtools/2.30.0


GENCODE="hg38.gencode.bed12"
CHR_SIZES="hg38_chr_sizes.txt"
ATAC_PEAKS="k562_atac_open_summits.bed"

echo "Creating promoter regions..."
bedtools flank -i ${GENCODE} \
    -g ${CHR_SIZES} \
    -l 2000 -r 0 -s | \
    bedtools slop -i stdin \
    -g ${CHR_SIZES} \
    -l 0 -r 2000 -s > promoters.bed

echo "Identifying putative enhancers..."
bedtools subtract -a ${ATAC_PEAKS} \
    -b promoters.bed > k562_enh.bed

echo "Number of putative enhancers identified:"
wc -l k562_enh.bed
