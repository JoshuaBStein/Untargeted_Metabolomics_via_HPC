# 1. Set a default CRAN mirror
options(repos = c(CRAN = "https://cloud.r-project.org"))

# 2. Check/Install boxr if it's missing from the conda env
if (!requireNamespace("boxr", quietly = TRUE)) {
    install.packages("boxr")
}

setwd("add-wd-here")

install.packages("boxr")
library(boxr)
box_auth()

box_folder_id <- "add-box-id-here"
box_fetch(dir_id = box_folder_id, local_dir = "./mzML_data")
