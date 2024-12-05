# Purpose: Compare enhancers between K562 and GM12878 cell lines and prepare visualization data

WORKDIR=""
cd $WORKDIR
module load gcc/8.2.0 bedtools/2.30.0

CHR_SIZES="hg38_chr_sizes.txt"
GM12878_ENH="gm12878_active_enh.bed"

bedtools slop -i k562_active_enh.bed \
    -g ${CHR_SIZES} -b 50 \
    > k562_active_enh_101bp.bed

bedtools intersect -a k562_active_enh_101bp.bed \
    -b ${GM12878_ENH} -u \
    > shared_k562_gm12878_enhancers.bed

bedtools intersect -a k562_active_enh_101bp.bed \
    -b ${GM12878_ENH} -v \
    > k562_specific_enhancers.bed

bedtools intersect -a ${GM12878_ENH} \
    -b k562_active_enh_101bp.bed -v \
    > gm12878_specific_enhancers.bed

head -n 500 shared_k562_gm12878_enhancers.bed > shared_500.bed
head -n 500 k562_specific_enhancers.bed > k562_specific_500.bed
head -n 500 gm12878_specific_enhancers.bed > gm12878_specific_500.bed

echo "Enhancer overlap statistics:"
wc -l k562_specific_enhancers.bed
wc -l gm12878_specific_enhancers.bed
wc -l shared_k562_gm12878_enhancers.bed
