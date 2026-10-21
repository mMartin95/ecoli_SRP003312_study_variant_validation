# Pipeline Scripts

This directory contains the automated bash scripts for the NGS variant calling pipeline.

## Execution Order

1. `01_qc_and_trimming.sh` - Quality control (FastQC/MultiQC) and adapter trimming (`fastp`).
2. `02_mapping_and_coverage.sh` - Read alignment (`bwa mem`), BAM sorting, coverage stats, and duplicate marking (`samtools`).
3. `03_variant_calling.sh` - Genotype likelihood computation and raw variant calling (`bcftools`).
4. `04_annotation.sh` - Chromosome renaming, hard filtering, and functional annotation (`SnpEff`).
5. `05_structural_variants.sh` - Structural variant detection (`Delly`) and genomic intersection (`bedtools`).

## Prerequisites
Ensure the Conda environment is activated before execution:
```bash
conda env create -f environment.yml
conda activate ecoli-variant-env
