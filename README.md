# CPTACBiolinks
## Introduction
CPTACBiolink is an R package to programmatically obtain and analyze multi-omics data generated in the  [Clinical Proteomic Tumor Analysis Consortium](https://proteomics.cancer.gov/programs/cptac).
Currently the arkive contains mutliple profiling (including genomics, transcriptiomics, proteomics, phospho-proteimics and others) for more than 12 tumor types.
## Installation
```
library(devtools)
install_github("miccec/CPTACBiolink")
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
