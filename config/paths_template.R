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
