#!/usr/bin/env bash
# =============================================================================
# Script: 05_structural_variants.sh
# Description: Structural Variant (SV) calling using Delly and genomic interval 
#              annotation/overlap evaluation using Bedtools.
# =============================================================================

set -e

# 1. CONFIGURATION & VARIABLES
SAMPLE="SRR0646432 #you can change it for different sample, but if you want to use the second sample rewrite it for SRR064643
THREADS=4

REF_DIR="data/reference"
REF_FASTA="${REF_DIR}/ecoli_K12.fna"   # Uprav podle své reference (např. NC_000913.3)
ALN_DIR="data/aligned_bam"
SV_DIR="data/sv_results"
ANNOTATION_GFF="${REF_DIR}/ecoli_K12.gff" # GFF soubor pro bedtools intersect

# 2. INPUT CHECK
if [ ! -f "${ALN_DIR}/${SAMPLE}_final.bam" ]; then
    echo "[ERROR] Final BAM file not found: ${ALN_DIR}/${SAMPLE}_final.bam"
    exit 1
fi

if [ ! -f "${REF_FASTA}" ]; then
    echo "[ERROR] Reference genome not found: ${REF_FASTA}"
    exit 1
fi

mkdir -p "${SV_DIR}"

echo "Starting Structural Variant (SV) Pipeline for sample: ${SAMPLE}"

# 3. DELLY SV CALLING
echo "[1/3] Running Delly to detect structural variants..."
# Delly detects deletion, duplication, inversions and translocations
delly call -g "${REF_FASTA}" "${ALN_DIR}/${SAMPLE}_final.bam" -o "${SV_DIR}/${SAMPLE}_delly_raw.bcf"

# 4. FILTERING SOMATIC/PASS VARIANTS
echo "[2/3] Filtering Delly BCF output for high-confidence PASS variants..."
bcftools view -i "FILTER='PASS'" "${SV_DIR}/${SAMPLE}_delly_raw.bcf" -O b -o "${SV_DIR}/${SAMPLE}_delly_filtered.bcf"
bcftools index "${SV_DIR}/${SAMPLE}_delly_filtered.bcf"

# Konversion to VCF file
bcftools view "${SV_DIR}/${SAMPLE}_delly_filtered.bcf" > "${SV_DIR}/${SAMPLE}_delly_filtered.vcf"

TOTAL_SVS=$(bcftools view -H "${SV_DIR}/${SAMPLE}_delly_filtered.bcf" | wc -l)
echo "Total high-confidence structural variants detected: ${TOTAL_SVS}"

# 5. BEDTOOLS INTERSECT (Anotace genů zasažených strukturální variantou)
echo "[3/3] Finding genes affected by structural variants using Bedtools..."
if [ -f "${ANNOTATION_GFF}" ]; then
    # Convert VCF to BED intervals and find overlaps with GFF file
    bedtools intersect -a "${SV_DIR}/${SAMPLE}_delly_filtered.vcf" -b "${ANNOTATION_GFF}" -wa -wb > "${SV_DIR}/${SAMPLE}_affected_genes.txt"
    echo "Saved affected genes/features to ${SV_DIR}/${SAMPLE}_affected_genes.txt"
else
    echo "[WARNING] GFF annotation file not found at ${ANNOTATION_GFF}. Skipping Bedtools intersection."
fi

echo "[SUCCESS] Structural variant pipeline completed successfully!"

