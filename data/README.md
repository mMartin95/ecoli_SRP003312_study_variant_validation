# Data Directory

This directory stores the essential reference genome, raw variant calls, structural variant datasets, and functional annotation outputs required for the *E. coli* K-12 genomic analysis pipeline.

## Contents

- `ecoli_K12.fna`  
  **Reference Genome**: The standard *Escherichia coli* K-12 reference sequence in FASTA format, serving as the coordinate backbone for read mapping (`bwa`), pileup generation, and visual validation in IGV.

- `raw_variants.vcf` 
  **Raw Variants**: Unfiltered Variant Call Format (VCF) file containing raw single nucleotide polymorphisms (SNPs) and small indels computed via `bcftools mpileup/call`.

- `single_target_deletion.vcf`
  **Structural Variants**: VCF file capturing large structural variations and specific target deletion events (such as the ~56 kb chromosomal deletion) detected by structural variant callers.

- `final_annotated_deletion.txt`  
  **Annotated Features**: Processed tabular text file resulting from `bedtools intersect`, mapping the structural deletion breakpoints directly to affected genes and operons (e.g., *hipAB*, *marRAB*).
