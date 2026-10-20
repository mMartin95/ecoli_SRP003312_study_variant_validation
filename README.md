# E. coli isobutanol tolerance genomics analysis

Variant validation, structural variation (SV) pipeline, and methodological impact assessment for isobutanol-tolerant *Escherichia coli* strains.

---

## Project overview

This repository contains a comprehensive structural variation analysis pipeline focused on identification of genetic drivers of **isobutanol tolerance** in *E. coli* by comparing control (SRR064642) and adapted strain (SRR064643)
The graphical scheme and more information is mentioned in the E.coli_study_SRP003312.jpg

---

## Processing of the samples:

Samples of E. coli SRR064642 and SRR064642 were processed.

The sequencing datasets underwent a processing pipeline:
- **Quality control**: Checked using `FastQC` (identifying adapter content and low-quality 3' ends).
- **Trimming**: Processed using `fastp` (minimum length 50 bp, minimum quality score Q20).
- **Quality control of trimmed reads**: Checked using `FastQC` and html report of both (raw and trimmed reads) using `MultiQC` 
- **Alignment**: Mapped to the *E. coli* K12 reference genome using `BWA`. Resulting SAM files were converted to BAM files, coordinate-sorted, and indexed using `samtools`.
- **Alignment metrics**: 
	- *Mapping efficiency* - Achieved a high overall read-mapping rate of sample SRR064642 (control) **92.11%** against the reference and read-mapping rate of sample SRR064643 (adapted strain) **92.85%**.
	- *Mapping coverage* - The sequencing achieved a broad coverage across the bacterial genome, spanning **98.78%** of the reference genome for SRR064642 (control) and **97.91%** of the reference genome for SRR064643 (adapted strain.)
- **Duplicate removal and methodological control**: Evaluated using Picard `MarkDuplicates`. Consequently, unfiltered sorted BAMs were retained for structural variant analysis.
- **Variant calling and annotation**: 
  - **SNPs and indels**: Generated using `bcftools mpileup | bcftools call`, filtered using QUAL > 30 && DP >= 10 && MQ > 30 and functionally annotated using `snpEff`.
  - **Structural variants (SVs)**: Detected using `Delly`, filtered using `bcftools view` to contain only PASS variants and annotated using `bedtools intersect` against genomic E. coli GFF file.

---

## Key findings:

Based on the filtration of samples and comparison of adapted strain and control sample, the adapted strain contained mutations:

| Gene symbol | Genomic impact / Mutation type | Protein / Functional Impact | Functional Consequence|
| :--- | :--- | :--- | :--- |
| **polA** | c.1168C>G | p.Leu390Val | DNA polymerase I disruption |
| **hipA-flxA locus** | **~56 kb Deletion** (`DEL00000097`, 1,590,764–1,647,025) | Loss-of-function / Complete deletion of **68 genes** | Encompasses *hipAB* toxin-antitoxin system, *marCRA* multiple antibiotic resistance locus, and cryptic prophage Qin components |

| Region / Location | Variant Details | Biological context | 
| :--- | :--- | :--- | :--- |
| **Upstream ydeP / Intergenic yneL-hipA** | c.-4284A>G |Regulatory region / Promoter variant located near the 56 kb deletion breakpoint, potentially affecting expression of stress-response genes (ydeP / hipA locus) | 
| **Upstream ydeP / Intergenic yneL-hipA** | c.-4292T>C | Upstream regulatory mutation adjacent to the hipAB toxin-antitoxin and solvent-stress adaptation loci.|

### 2. Large structural variation (56 kb Deletion)
- **Variant ID**: `DEL00000097` (Genomic coordinates: `1,590,764 – 1,647,025`)
- **Total Impact**: Deletion of **~68 genes/features**, spanning major regulatory, transport, and prophage elements.
- **Key Functional Groups Affected**:
  - **Toxin-Antitoxin Systems**: Complete removal of the *hipAB* operon (`hipA`, `hipB`), altering persistence and stress-response pathways.
  - **Antibiotic & Solvent Resistance**: Deletion of the *marRAB* locus (`marC`, `marR`, `marA`, `marB`), directly impacting transcriptional regulation of membrane permeability and efflux mechanisms.
  - **Quorum Sensing & Transport**: Loss of the *lsr* operon (`lsrACDBFKG`) responsible for autoinducer-2 processing.
  - **Biofilm & Stress Signaling**: Elimination of multiple diguanylate cyclases (`dgcF`, `dgcZ`) and cold-shock proteins (`cspI`, `cspB`).
- *Note: The complete, unfiltered list of all 68 deleted features parsed from GFF annotations is available in data/final_annotated_deletion.txt`.*

---

## Comparison with published study
The study is provided in repository study.
While the pipeline successfully recovered the primary genetic drivers identified in the reference study—specifically the *polA* missense mutation (`p.Leu390Val`) and the ~56 kb structural deletion (`DEL00000097`) —the 25 insertion sequence (IS) elements reported in the original paper were not fully resolved by standard short-read SV callers (Delly) due to mapping ambiguities inherent to repetitive mobile elements.

---

## IGV screening:

IGV tool downloaded from IGV website: https://igv.org/doc/desktop/ was used for the visualization of the key identified variants, specifically *polA* and the *hipA-flxA* deletion, wherein the figure featuring the deletion is divided into 3 parts.

All generated figures are located in the `igv_snapshots/` directory.
