# Chromatin Analysis Methods Documentation

## Overview
This document details the computational methods used to analyze chromatin accessibility and regulatory elements in K562 (leukemia) and GM12878 (non-cancerous) cell lines. Our analysis pipeline integrates ATAC-seq and ChIP-seq data to identify and characterize cell-type specific enhancers and their associated transcription factors.

## Data Sources
All data was obtained from the ENCODE project database:
- K562 ATAC-seq open peak summits
- K562 H3K27ac ChIP-seq alignment data
- K562 Input control alignment data
- GM12878 active enhancer regions
- Human genome reference (hg38)

## Analysis Pipeline

### 1. Enhancer Identification
We first identified putative enhancer regions in K562 cells using ATAC-seq data. The process involved:

1. Creating promoter exclusion regions by:
   - Extending 2kb upstream and 2kb downstream from annotated transcription start sites
   - Using the GENCODE gene annotation database for hg38
   
2. Identifying putative enhancers by:
   - Starting with ATAC-seq accessible regions (open chromatin)
   - Removing any regions that overlapped with the defined promoter regions
   - Resulting in a set of non-promoter accessible regions

### 2. Active Enhancer Analysis
We identified active enhancers using H3K27ac ChIP-seq data through the following steps:

1. Peak calling using MACS2:
   - Used broad peak calling mode appropriate for histone modifications
   - Applied an effective genome size of 2.9e9
   - Utilized input controls for background correction

2. Active enhancer definition:
   - Extended H3K27ac peak boundaries by 100bp in each direction
   - Identified overlaps between ATAC-seq enhancers and H3K27ac peaks
   - Created separate sets of active and inactive enhancers for comparison

### 3. Comparative Analysis
To compare regulatory elements between cell types, we:

1. Standardized region sizes:
   - Created 101bp windows centered on K562 ATAC-seq peaks
   - Ensured fair comparison with GM12878 enhancer regions

2. Identified distinct and shared enhancer sets:
   - K562-specific enhancers (no overlap with GM12878)
   - GM12878-specific enhancers (no overlap with K562)
   - Shared enhancers (overlapping between cell types)

3. Generated visualization data:
   - Created 500-region subsets for each category
   - Prepared normalized coverage tracks for both ATAC-seq and H3K27ac

### 4. Motif Analysis
We performed transcription factor motif analysis using HOMER:

1. Sequence preparation:
   - Selected top 1000 enhancers from each cell-type specific set
   - Ranked by ATAC-seq signal strength (peak q-value)
   - Extracted corresponding genomic sequences

2. Motif discovery:
   - Performed discriminative motif finding between cell types
   - Used one cell type's sequences as background for the other
   - Identified enriched transcription factor binding motifs

## Quality Control
Throughout the analysis, we implemented several quality control measures:

1. Data validation:
   - Verified promoter region sizes (4kb windows)
   - Confirmed enhancer counts matched between processing steps
   - Validated complete separation of active/inactive enhancer sets

2. Signal verification:
   - Generated heatmaps to confirm signal patterns
   - Verified H3K27ac enrichment at active enhancers
   - Confirmed cell-type specificity of identified regions

## Software Dependencies
- bedtools (v2.30.0)
- MACS2 (v2.2.7.1)
- HOMER (v4.10.3)
- deeptools (v3.3.0)
- Unix/Linux environment

## Statistical Considerations
All peak calling and enrichment analyses incorporated appropriate background controls and multiple testing corrections. Motif analysis significance was assessed using hypergeometric testing as implemented in HOMER.
