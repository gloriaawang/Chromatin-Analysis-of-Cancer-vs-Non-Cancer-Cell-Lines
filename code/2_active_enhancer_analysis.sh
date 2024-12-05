# Purpose: Identify active enhancers using H3K27ac ChIP-seq data and create visualization data

WORKDIR=""
cd $WORKDIR
module load gcc/8.2.0 bedtools/2.30.0 macs/2.2.7.1 deeptools/3.3.0

CHR_SIZES="hg38_chr_sizes.txt"
CHIP_BAM="k562_k27ac_chip.bam"
INPUT_BAM="k562_input.bam"

macs2 callpeak -t ${CHIP_BAM} \
    -c ${INPUT_BAM} \
    --format BAM --name k562_k27ac \
    --gsize 2.9e9 --broad

bedtools slop -i k562_k27ac_peaks.broadPeak \
    -g ${CHR_SIZES} -b 100 \
    > k562_k27ac_extended_peaks.bed
    
bedtools intersect -a k562_enh.bed \
    -b k562_k27ac_extended_peaks.bed -u > k562_active_enh.bed

bedtools intersect -a k562_enh.bed \
    -b k562_k27ac_extended_peaks.bed -v > k562_inactive_enh.bed

head -n 500 k562_active_enh.bed > k562_active_enh_500subset.bed
head -n 500 k562_inactive_enh.bed > k562_inactive_enh_500subset.bed

bamCoverage -b ${CHIP_BAM} \
    --normalizeUsing RPKM \
    --skipNonCoveredRegions \
    -o k562_k27ac.bw
