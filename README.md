# Metabolomics Analysis Pipeline on Rutgers Amarel HPC

This repository contains R scripts used to run a metabolomics data analysis pipeline on the **Rutgers Amarel High-Performance Computing (HPC) cluster**. The pipeline uses [MetaboAnalystR](https://github.com/xia-lab/MetaboAnalystR) and [OptiLCMS](https://github.com/xia-lab/OptiLCMS) to process raw mass spectrometry data and identify metabolic pathways.

---

## 🧠 What is HPC and Why Do We Need It?

A regular laptop or desktop computer has limited memory (RAM) and processing power. Mass spectrometry data files (`.mzML`) are very large, and the computations required to process them — peak detection, alignment, database searching — can take many hours or even crash a personal computer.

An **HPC cluster** (like Rutgers Amarel) is essentially a massive collection of powerful computers that you can send your analysis jobs to. Instead of running the script on your laptop, you write a small "instruction file" (called a **SLURM script**) that tells the cluster *how many resources you need* (memory, CPUs, time), then the cluster runs your R script in the background while you go do other things.

---

## 📁 Repository Structure

```
├── environment.yml                          # Conda environment with all required software
├── submit_R_script.slurm                    # SLURM job submission script (the "instruction file" for the cluster)
│
├── 1_install_metaboanalyst.R                # Step 1a: Install all required R packages
├── 1_Run_to_initialize_MetaboAnalystR.R     # Step 1b: Alternative initialization script
│
├── 2_retrieve_files.R                       # Step 2: Download raw .mzML data files from Box cloud storage
├── 2_Data_Analysis_Annotated_List_Final.R   # Step 2 (local version): Full annotated data analysis pipeline (run on local PC first)
│
├── 3_step_1.R                               # Step 3: Peak detection, annotation, and MS/MS processing (cluster version)
├── 3_Mummicgog_Analysis_on_MS1_peak_Table.R # Step 3 (local): Mummichog pathway analysis (local version)
│
└── 4_analysis.R                             # Step 4: Mummichog pathway enrichment analysis (cluster version)
```

---

## ⚙️ How to Set Up the Environment

Before running any scripts, you need to recreate the software environment on the cluster. This ensures all the correct R packages and libraries are installed at the right versions.

### What is a Conda environment?
Think of it like a self-contained box of tools. The `environment.yml` file is a list of every tool (R packages, system libraries) needed. Conda reads this list and installs everything automatically.

**To create the environment on Amarel:**
```bash
conda env create -f environment.yml
conda activate metabo_fast
```

> **Note:** The `environment.yml` is configured for Linux (the operating system used by Amarel). It will not work directly on Windows.

---

## 🚀 How to Run the Pipeline

### Step 1 — Install R Packages
Run this **once** to install MetaboAnalystR and all its dependencies into your environment.

```bash
Rscript 1_install_metaboanalyst.R
```

### Step 2 — Retrieve Your Data Files
Edit `2_retrieve_files.R` to fill in your working directory and Box folder ID, then run it to download your `.mzML` raw data files from Box cloud storage onto the cluster.

```bash
Rscript 2_retrieve_files.R
```

### Step 3 — Peak Detection & Annotation
Edit `3_step_1.R` to fill in the correct file paths for your data on the cluster, then submit it to the cluster using the SLURM script (see below).

### Step 4 — Pathway Analysis (Mummichog)
Edit `4_analysis.R` to point to your processed peak table CSV file, then submit it to the cluster.

---

## 📋 How to Submit a Job to the Cluster

The file `submit_R_script.slurm` is the instruction file you hand to the Amarel cluster. It tells the cluster:

- How much memory to reserve (128 GB)
- How many CPU cores to use (12)
- How long the job is allowed to run (up to 24 hours)
- Which R script to execute

**Before submitting, edit the placeholders in `submit_R_script.slurm`:**

| Placeholder | Replace with |
|---|---|
| `add-user-id-here` | Your Amarel NetID (e.g., `jbs263`) |
| `add-name-here` | A short name for your job (e.g., `metabo_step3`) |
| `add-file-name-here.R` | The R script you want to run (e.g., `3_step_1.R`) |

**Then submit the job from the Amarel terminal:**
```bash
sbatch submit_R_script.slurm
```

After submitting, the cluster will create two log files:
- `<job_number>.out` — normal output printed by the script
- `<job_number>.err` — any error messages

You can check the status of your job with:
```bash
squeue -u your_netid
```

---

## 🔬 What Does the Analysis Actually Do?

| Script | What it does |
|---|---|
| `1_install_metaboanalyst.R` | Installs MetaboAnalystR and all its dependencies |
| `2_retrieve_files.R` | Downloads raw mass spec data (`.mzML` files) from Box to the cluster |
| `3_step_1.R` | Detects peaks in the raw data, annotates features, and processes MS/MS spectra |
| `4_analysis.R` | Runs **Mummichog** pathway analysis — this maps detected metabolite peaks to known human metabolic pathways to find which biological processes are changing between sample groups |

The sample groups analyzed were **M0, M1, and PCaP** (prostate cancer progression stages), comparing macrophage polarization states.

---

## 📌 Important Notes

- **Scripts 2 and 3 (local versions)** contain hardcoded Windows paths (`C:/Users/eagle/...`). These were used for initial development on a local PC and are kept here for reference. The numbered scripts (`3_step_1.R`, `4_analysis.R`) are the cluster-ready versions with placeholder paths.
- The MS/MS database search step (`PerformDBSearchingBatch`) requires a local copy of the `MS2ID_Bio_v09102023.sqlite` database file, which is commented out by default. Download it separately if needed.
- The `environment.yml` includes a hardcoded `prefix` path at the bottom (`/home/jbs263/miniconda3/envs/metabo_fast`). You can ignore or delete that line — it does not affect environment creation.

---

## 🛠️ Dependencies

All dependencies are captured in `environment.yml`. Key packages include:

- **R 4.4.1**
- **MetaboAnalystR** — core metabolomics analysis
- **OptiLCMS** — LC-MS data processing and peak optimization
- **xcms** — chromatographic peak detection
- **mzR / MSnbase** — reading raw mass spectrometry files
- **ggplot2, plotly** — visualization

---

## 📬 Questions?

If you run into issues, check the `.err` log file generated by your SLURM job first — it usually tells you exactly what went wrong.
