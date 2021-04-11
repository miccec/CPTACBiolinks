# CPTACBiolinks
## Introduction
CPTACBiolink is an R package to programmatically obtain and analyze multi-omics data generated in the  [Clinical Proteomic Tumor Analysis Consortium](https://proteomics.cancer.gov/programs/cptac).
Currently the archive contains mutliple profiling (including genomics, transcriptiomics, proteomics, phospho-proteimics and others) for more than 12 tumor types.
## Installation
```
library(devtools)
install_github("miccec/CPTACBiolinks")
library(CPTACBiolinks)
```

## Usage

```
## GET DATASETS LIST
getDatasetsList()
```
will produce the list of abailable cancer dataset


```
## GET DATA LIST OF CANCER
CancerType = "Endometrial"
getOmicsList(CancerType)

```
with the function `getOmicsList` you get all the available data for a specific cancer dataset.
```
## GET MULTI DATA TYPE OF CANCER
data_type = c("RNAseq (HiSeq, Gene level, Tumor)", "Proteome (Gene level, TMT Unshared Log Ratio, Tumor)")
endometrial_omics = getData(CancerType,data_type)
names(endometrial_omics)
```
Once you have know available data for your  project you can download the desired data with ```getData```. If you want to download all the data, you can use "All" as parameter to getData.

```
## GET ALL DATA OF CANCER
all_endometrial = getData(CancerType,"All")
names(all_endometrial)
```
