library(OptiLCMS);
library(MetaboAnalystR);
library(parallel);
library(mzR);
library(xcms);

# 1. Set Working Directory to your cluster folder (NOT your C: drive)
setwd('add-wd-here')

# 2. DEFINING FILES
# I have fixed the paths to point to the cluster.
# I have fixed the typo (PCaP -> PCap).
# I have uncommented the blank file (add it back if you need it).

files = c('add-file-1-here',
          'add-file-2-here',
          'add-file-3-here', 
          'add-file-4-here',
          'add-file-5-here')

# 3. ROI EXTRACTION
mSet <- PerformROIExtraction(datapath = files, rt.idx = 0.9, rmConts = TRUE)

# 4. PARAMETER OPTIMIZATION
# ncore=4 is correct. Ensure your SLURM script has #SBATCH --cpus-per-task=4 and #SBATCH --mem=64G
best_params <- PerformParamsOptimization(mSet, param = SetPeakParam(platform = "general"), ncore = 4);
best_params[23] = "positive" 

# 5. IMPORT DATA
# Changed from C:/Users... to the correct cluster folder
importFolder <- "/scratch/jbs263/MetabloAnalystFiles/Brandon/mzMLfiles"
mSet <- ImportRawMSData(path = c(importFolder), plotSettings = SetPlotParam(Plot = T))

# 6. DATA PROCESSING 
mSet <- PerformPeakProfiling(mSet, Params = best_params, plotSettings = SetPlotParam(Plot = T))

# 7. FEATURE ANNOTATION
annParams <- SetAnnotationParam(
  polarity = 'positive',
  perc_fwhm = 0.6,
  mz_abs_iso = 0.005,
  max_charge = 2,
  corr_eic_th = 0.85,
  mz_abs_add = 0.001,
);

mSet <- PerformPeakAnnotation(mSet, annParams)

# 8. FEATURE TABLE GENERATION
mSet <- FormatPeakList(mSet, annParams, filtIso = FALSE, filtAdducts = FALSE, missPercent = 0.75);

# 9. EXPORT RESULTS
Export.Annotation(mSet);
Export.PeakTable(mSet);

###################################################################################
#### MS/MS SECTION
###################################################################################

# Import DDA MS/MS spectra
mSet <- PerformMSnImport(filesPath = files,
                         mSet = mSet,
                         acquisitionMode = 'DDA')

# DDA MS/MS spectra Deconvolution 
mSet <- PerformDIADeconvolution(mSet,
                                min_width = 5,
                                span = 0.4,
                                ncores = 1L)

# Spectrum consensus of replicates
mSet <- PerformSpectrumConsenus(mSet,
                                use_rt = FALSE,
                                user_dbCorrection = FALSE)

# Reference database searching
# NOTE: Ensure "ms2_db" folder exists inside /scratch/jbs263/MetabloAnalystFiles/Brandon/
#mSet <-PerformDBSearchingBatch(mSet,
#                               database_path = "ms2_db/MS2ID_Bio_v09102023.sqlite",
#                               use_rt = FALSE,
#                               enableNL = FALSE,
#                               ncores = 1L)
