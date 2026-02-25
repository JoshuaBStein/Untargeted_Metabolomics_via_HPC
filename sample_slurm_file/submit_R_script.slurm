#!/bin/bash
#SBATCH --partition=main
#SBATCH --job-name=add-name-here
#SBATCH --output=%j.out
#SBATCH --error=%j.err
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --mem=128G
#SBATCH --time=23:59:59

# 1. Clear any existing modules
module purge

# 2. Source Conda (Using your specific miniconda path)
source /home/add-user-id-here/miniconda3/etc/profile.d/conda.sh

# 3. Activate the metabo_fast environment
conda activate metabo_fast

# 5. Run the R download script
# Make sure download_data.R is in the same folder you submit this from
Rscript add-file-name-here.R
