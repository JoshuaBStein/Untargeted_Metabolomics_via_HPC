
################################################################################
##############    Mummicgog Analysis on MS1 peak Table            ##############
################################################################################

library(MetaboAnalystR)
library(fitdistrplus)

setwd('add-wd-here');


rm(list = ls())

mSet <- InitDataObjects("pktable", "mummichog", FALSE)
mSet <- SetPeakFormat(mSet, "colu")
mSet <- UpdateInstrumentParameters(mSet, 22.5, "positive", "yes", 0.02);
mSet <- SetRTincluded(mSet, "seconds")

# mSet <- Read.TextData(mSet, "M1_M1Tx.csv", "mpt", "disc");
mSet <- Read.TextData(mSet, "add-title-here.csv", "mpt", "disc");

mSet <- SanityCheckMummichogData(mSet)

mSet <- ReplaceMin(mSet);
mSet <- SanityCheckMummichogData(mSet)
mSet <- FilterVariable(mSet, "none", -1, "F", 25, F)

mSet <- PreparePrenormData(mSet)
mSet <- Normalization(mSet, "MedianNorm", "LogNorm", "AutoNorm", ratio=FALSE, ratioNum=20)

mSet <- PlotNormSummary(mSet, "norm_0_", "png", 72, width=NA)
mSet <- PlotSampleNormSummary(mSet, "snorm_0_", "png", 72, width=NA)

mSet <- SetPeakEnrichMethod(mSet, "mum", "v2")
mSet <- PreparePeakTable4PSEA(mSet)

pval <- sort(mSet[["dataSet"]][["mummi.proc"]][["p.value"]])[ceiling(length(mSet[["dataSet"]][["mummi.proc"]][["p.value"]])*0.1)]

mSet <- SetMummichogPval(mSet, pval)
mSet <- PerformPSEA(mSet, "hsa_mfn", "current", 3 , 100)

# mSet <- PlotPeaks2Paths(mSet, "peaks_to_paths_0_M1_M1Tx", "png", 72, width=NA)
mSet <- PlotPeaks2Paths(mSet, "add-title-here", "png", 72, width=NA)
