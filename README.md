# Chromatin Analysis of Cancer vs Non-Cancer Cell Lines
**March 2023**

A computational analysis comparing regulatory elements between K562 (cancer) and GM12878 (non-cancer) cell lines using ATAC-seq and ChIP-seq data.

# Key Findings
- Identified 203,874 K562 ATAC-seq open regions and 121,949 putative enhancer regions
- Found 30,020 H3K27ac-marked active K562 enhancer regions
- Discovered significant enrichment of GATA3 motifs in K562-specific enhancers
- GM12878 cells showed enrichment for GATA4 and MYB motifs
- Found 3,209 shared enhancers between cell types

# Methods
1. Enhancer Identification
2. Active Enhancer Analysis with H3K27ac ChIP-seq
3. Comparative Analysis between Cell Lines
4. Motif Discovery in Cell-type Specific Enhancers

# Dependencies
- bedtools v2.30.0
- MACS2 v2.2.7.1
- HOMER v4.10.3
- deeptools v3.3.0
- Unix/Linux environment
