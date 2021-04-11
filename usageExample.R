setwd("~/CPTACBiolinks/CPTACBiolinks")
source("./R/loadData.R")
source("./R/processData.R")


library(devtools)
install_github("miccec/CPTACBiolinks")
library(CPTACBiolinks)

## GET DATASETS LIST
getDatasetsList()

## GET DATA LIST OF CANCER
CancerType = "Endometrial"
getOmicsList(CancerType)

## GET ONE DATA TYPE OF CANCER
DataType = "Phosphoproteome (Gene level, Tumor)"
phosphopro = getData(CancerType,DataType)
head(phosphopro)

## GET MULTI DATA TYPE OF CANCER
DataType = c("RNAseq (HiSeq, Gene level, Tumor)", "Proteome (Gene level, TMT Unshared Log Ratio, Tumor)")
endometrial_omics = getData(CancerType,DataType)
names(endometrial_omics)

## GET ALL DATA OF CANCER
all_endometrial = getData(CancerType,"All")
names(all_endometrial)


## TOP n MUTATED GENES
Mutation = all_endometrial$`Mutation (Gene level, Tumor)`
topMutatedGene(Mutation, 10)


## SUBSET RNAseq MATRIX ONLY PATIENT WITH GENE MUTATION
RNAseq = all_endometrial$`RNAseq (HiSeq, Gene level, Tumor)`
Mutation = all_endometrial$`Mutation (Gene level, Tumor)`
gene = topMutatedGene(Mutation)

RNAseq_sub = subsetSharedFetures(RNAseq,Mutation,gene$geneID)


