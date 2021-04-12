START_INDEX = "https://dl.dropbox.com/s/ofxteh9ovmftcqf/index.csv"
library(maftools)

## Read ulr as table
readUrl <- function(url, sep = ",", rownames = 0){
  
  ind = data.table::fread(url, sep = "\t", stringsAsFactors = FALSE, 
                                                    verbose = FALSE, data.table = TRUE, showProgress = TRUE, 
                                                    header = TRUE, fill = TRUE)
  
  if(rownames){
    ind = data.frame(ind,row.names = 1)
  }
  
  return(ind)
}

## Get datasets index
getStartIndex <- function(){
  ind = readUrl(START_INDEX)
  return(ind)
}

## Get datasets list (user)
#' Datasets list
#'
#' Returns the list of available cancer datasets
#' 
#' @return
#' @export
#'
#' @examples
getDatasetsList <- function(){
  
  ind = getStartIndex()
  print("Avaiable datasets:")
  return(ind[order(ind$Dataset_name),1:2])
}

getCancerIndex <- function(CancerType){
  
  ind = getStartIndex()
  url_ind <- ind$Data_link[toupper(ind$Dataset_name) == toupper(CancerType)]
  
  ind = readUrl(url_ind)
  return(ind)
}

## Get omics datasets of cancer (user)
#' Omics datasets list
#'
#' Returns the list of available omics data of cancer
#'
#' @param CancerType 
#'
#' @return
#' @export
#'
#' @examples
getOmicsList <- function(CancerType){
  
  print(paste("Avaiable data for",CancerType,":"))
  
  ind = getCancerIndex(CancerType)
  return(sort(ind$OMICS_Dataset))
}

readMaf <- function(url){

  filename <- "mutation.maf.gz"
  
  #data = data.table::fread(url, sep = "\t", stringsAsFactors = FALSE, 
  #                         verbose = FALSE, data.table = TRUE, showProgress = TRUE, 
  #                         header = TRUE, fill = TRUE, skip = "Hugo_Symbol", 
  #                         quote = "")
  
  download.file(url, filename, quiet = TRUE)
  data <- read.maf(filename)
  unlink(filename)
  return(data)
}


## Load file
loadData <- function(url){
  
  if(substr(url, nchar(url)-5, nchar(url)-3) == "maf"){
    data = readMaf(url)
  }else{
    data = readUrl(url, sep = "\t", rownames = 1)
  }
  
  return(data)
}

## Get data of a dataset
#' Get omics data
#'
#' Allow to download one or more omics data from the dataset
#'
#' @param CancerType 
#' @param DataName 
#'
#' @return
#' @export
#'
#' @examples
getData <- function(CancerType,DataName){
  
  ind = getCancerIndex(CancerType)
  
  if(length(DataName) == 1 && toupper(DataName) == "ALL"){
    DataName = ind$OMICS_Dataset 
  }
  
  data = c()
  if(length(DataName) == 1){
    print(paste("Loading", DataName))
    url_ind <- ind$url[toupper(ind$OMICS_Dataset) == toupper(DataName)]
    data = loadData(url_ind)
  }else{
    for (type in DataName){
      url_ind <- ind$url[toupper(ind$OMICS_Dataset) == toupper(type)]
      if(nchar(url_ind)>0){
        print(paste("Loading", type))
        data[[type]] = loadData(url_ind)
      }else{
        print(paste("Missing url for", type))
      }
    }
  }
  
  return(data)
}

## Get all data of a type in a dataset
#' Get omics data type
#'
#' Allow to download one type of omics data from the dataset
#' 
#' "Clinical"        "SCNV"            "Mutation"        "Acetylproteome"  "Phosphoproteome" "Proteome"        "RNAseq"         
#' "miRNA"           "Circular"        "Methylation"     "CNV"             "Glycoproteome"   "RPPA" 
#'
#' @param CancerType 
#' @param DataType 
#'
#' @return
#' @export
#'
#' @examples
getDataType <- function(CancerType,DataType){
  
  ind = getCancerIndex(CancerType)
  
  data = c()

  print(paste("Loading", DataType))
  indx <- grep(toupper(DataType),  toupper(ind$OMICS_Dataset))
  for (i in indx){
    url_ind <- ind$url[i]
    type <- ind$OMICS_Dataset[i]
    data[[type]] = loadData(url_ind)
  }
  
  return(data)
}


