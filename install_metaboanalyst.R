metanr_packages <- function(){
  
  metr_pkgs <- c("impute", "pcaMethods", "globaltest", "GlobalAncova", "Rgraphviz", "preprocessCore", "genefilter", "sva", "limma", "KEGGgraph", "siggenes","BiocParallel", "MSnbase", "multtest","RBGL","edgeR","fgsea","devtools","crmn","httr","qs")
  
  list_installed <- installed.packages()
  
  new_pkgs <- subset(metr_pkgs, !(metr_pkgs %in% list_installed[, "Package"]))
  
  if(length(new_pkgs)!=0){
    
    if (!requireNamespace("BiocManager", quietly = TRUE))
      install.packages("BiocManager")
    BiocManager::install(new_pkgs)
    print(c(new_pkgs, " packages added..."))
  }
  
  if((length(new_pkgs)<1)){
    print("No new packages added...")
  }
}

metanr_packages()
install.packages("pacman")
install.packages("devtools")
install.packages("ellipse")
install.packages("iheatmapr")
install.packages("fitdistrplus")
BiocManager::install("xcms")



pacman::p_load(Cairo, progress, Rserve, pROC, caret, dplyr, glasso, gplots,igraph,
               plotly,backports, checkmate, Formula, htmlTable, estimability, 
               RcppArmadillo, ggrepel, entropy, Hmisc, rsm, RJSONIO, BiocGenerics,
               ProtGenerics, Biobase, zlibbioc, preprocessCore, affyio, limma, 
               affy, S4Vectors, Rhdf5lib, graph, mzID, pcaMethods, impute, vsn, 
               IRanges, BiocParallel, MsCoreUtils, mzR, RBGL, MSnbase)

devtools::install_github("xia-lab/MetaboAnalystR", build = TRUE, build_vignettes = TRUE, build_manual =T)
devtools::install_github("xia-lab/OptiLCMS", build = TRUE, build_vignettes = FALSE, build_manual =T)

