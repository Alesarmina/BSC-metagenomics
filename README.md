# BSC-metagenomics

Bioinformatic and statistical analysis code for the manuscript:

**Shotgun metagenomes of biological soil crusts from hot and cold deserts in Mexico**

This repository contains R Markdown notebooks and shell scripts used to analyze shotgun metagenomes from biological soil crusts collected in two contrasting Mexican deserts: Cuatro Ciénegas (CC) and Valle de Guadalupe (VG).

## Data availability

Raw metagenomic sequencing reads are deposited in the NCBI Sequence Read Archive (SRA) under BioProject accession number:

**PRJNA1478337**

Processed data and source tables for the manuscript figures are deposited in Figshare under reserved DOI:

**10.6084/m9.figshare.32719809**

During peer review, the Figshare dataset is available through a private review link.

## Repository structure

- `Rmd/`: R Markdown notebooks used for taxonomic, functional, and physicochemical analyses.
- `scripts/`: shell scripts used during preprocessing or mapping steps.
- `docs/`: documentation and script manifests.
- `data/`: placeholder folder. Processed data are not stored in this repository; they are available through Figshare.
- `outputs/`: placeholder folder for generated outputs.

## Main analyses

1. Species-level taxonomic community analysis using Kraken2/Bracken output.
2. Bray-Curtis PCoA and PERMANOVA.
3. Soil physicochemical PCA.
4. MetaCyc functional category heatmap.
5. MetaCyc and KO-level functional abundance analyses.
6. CLR-transformed KO abundance analysis.
7. Wilcoxon rank-sum tests, Benjamini-Hochberg correction, and Cliff's delta effect sizes.
8. Volcano plots and lollipop plots for selected functional categories.

## Software

The following tools were used in the broader analysis workflow:

- FastQC v0.12.1
- Trim Galore v0.6.10
- SPAdes v3.15.5
- Kraken2 v2.1.2
- Bracken v2.8
- MetaPhlAn v4.0.14
- HUMAnN v3.0
- KEGG database
- MetaCyc database

R package versions are documented in the corresponding R Markdown outputs and session information when available.

## License

Code is released under the MIT License. Data are available through Figshare under the license selected there.

## Reproducibility note

Some R Markdown files contain absolute local paths from the original analysis computer. These are preserved to document the original workflow. Users should download the processed data from Figshare and update the paths according to their own directory structure.

A template for local paths is provided in:

`config/paths_template.R`

A full audit of local absolute paths is provided in:

`docs/local_absolute_paths_audit.txt`

## Archived release

The analysis code is archived in Zenodo under DOI:

10.5281/zenodo.20737992
