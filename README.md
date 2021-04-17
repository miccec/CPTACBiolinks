# CPTACBiolinks
![image](vignettes/Uimages/CTPACBiolinks.png)
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
will produce the list of available cancer dataset

```
## GET DATA LIST OF CANCER
CancerType = "Endometrial"
getOmicsList(CancerType)

```
with the function `getOmicsList` you get all the available data for a specific cancer dataset.

```
## GET ALL DATASETS OF AN OMICS TYPE FROM CANCER
OmicsType = "Phosphoproteome"
phosphopro = getDataType(CancerType,OmicsType)
```

Once you have know available data for your  project you can download the desired data with the function `getDataType` you get all the available data for a specific omics type from cancer dataset.

```
## GET MULTI DATA TYPE OF CANCER
data_type = c("RNAseq (HiSeq, Gene level, Tumor)", "Proteome (Gene level, TMT Unshared Log Ratio, Tumor)")
endometrial_omics = getData(CancerType,data_type)
names(endometrial_omics)
```
otherwise you can use ```getData```, if you want to download specifics data or all the data, using "All" as parameter to getData.

```
## GET ALL DATA OF CANCER
all_endometrial = getData(CancerType,"All")
names(all_endometrial)
```

## Use Cases

* [Example difference RNAseq and Proteomics with and without Mutation](https://github.com/miccec/CPTACBiolinks/blob/main/vignettes/useCase.md)
* [Example correlation beetween RNAseq and Proteomics](https://github.com/miccec/CPTACBiolinks/blob/main/vignettes/useCase2.md)
