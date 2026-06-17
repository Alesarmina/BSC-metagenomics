# Reproducibility notes

This repository contains the analysis scripts used for the manuscript.

Some R Markdown files include absolute local paths from the original analysis computer. These paths are preserved to document the original computational workflow and file organization used during the analysis.

To reproduce the analyses on another computer:

1. Download the processed data package from Figshare.
2. Unzip the data package.
3. Copy `config/paths_template.R` to `config/paths_local.R`.
4. Edit `paths_local.R` so that `data_dir` points to the unzipped Figshare data folder.
5. Update input and output directories in each R Markdown file as needed.

Recommended local structure:

```text
project/
├── config/
│   ├── paths_template.R
│   └── paths_local.R
├── data/
│   ├── metadata/
│   ├── taxonomy/
│   ├── function_KO/
│   ├── function_categories/
│   ├── soil_physicochemistry/
│   └── figure_source_data/
├── Rmd/
├── scripts/
└── outputs/
uu
mkdir -p "$HOME/Desktop/BSC-metagenomics/config"

cat > "$HOME/Desktop/BSC-metagenomics/config/paths_template.R" <<'EOF'
# paths_template.R
# Copy this file to paths_local.R and edit the paths according to your computer.

# Root directory containing the processed data downloaded from Figshare.
# Example:
# data_dir <- "/path/to/BSC_metagenomics_Figshare_READY"

data_dir <- "data"

metadata_dir <- file.path(data_dir, "metadata")
taxonomy_dir <- file.path(data_dir, "taxonomy")
function_KO_dir <- file.path(data_dir, "function_KO")
function_categories_dir <- file.path(data_dir, "function_categories")
soil_physicochemistry_dir <- file.path(data_dir, "soil_physicochemistry")
figure_source_data_dir <- file.path(data_dir, "figure_source_data")

# Output directory for regenerated tables and figures.
output_dir <- "outputs"
