setwd("~/CPTAC-Biolinks/")
source("download.R")

## GET DATASETS LIST
getDatasetsList()

## GET DATA LIST OF CANCER
CancerType = "Endometrial"
getOmicsList(CancerType)

## GET ONE DATA TYPE OF CANCER
DataType = "Proteome (Gene level, TMT Unshared Log Ratio, Tumor)"
endometrial_proteomics = getData(CancerType,DataType)
head(endometrial_proteomics)

## GET MULTI DATA TYPE OF CANCER
data_type = c("RNAseq (HiSeq, Gene level, Tumor)", "Proteome (Gene level, TMT Unshared Log Ratio, Tumor)")
endometrial_omics = getData(cancer_type,data_type)
names(endometrial_omics)

## GET ALL DATA OF CANCER
all_endometrial = getData(CancerType,"All")
names(all_endometrial)