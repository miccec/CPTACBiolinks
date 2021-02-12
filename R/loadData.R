START_INDEX = "https://www.dropbox.com/s/u491n4g793k52f1/index.tsv?raw=1"
library(maftools)

## Read ulr as table
readUrl <- function(url, sep = ","){
  url_ind <- url(url) 
  ind = read.table(url_ind,sep = sep, header = TRUE)
  return(ind)
}

## Get datasets index
getStartIndex <- function(){
  ind = readUrl(START_INDEX)
  return(ind)
}

## Get datasets index (list user)
getDatasetsList <- function(){
  ind = getStartIndex()
  print("Avaiable datasets:")
  return(ind[,1:2])
}

## Get index of a dataset
getCancerIndex <- function(CancerType){
  ind = getStartIndex()
  url_ind <- ind$Data.link[toupper(ind$Dataset.name) == toupper(CancerType)]
  
  ind = readUrl(url_ind)
  return(ind)
}

## Get index of a dataset (list user)
getOmicsList <- function(CancerType){
  print(paste("Avaiable data for",CancerType,":"))
  
  ind = getCancerIndex(CancerType)
  return(ind[,1])
}

## Read a maf url
readMaf <- function(url){
  
  data = data.table::fread(url, sep = "\t", stringsAsFactors = FALSE, 
                           verbose = FALSE, data.table = TRUE, showProgress = TRUE, 
                           header = TRUE, fill = TRUE, skip = "Hugo_Symbol", 
                           quote = "")
  
  return(read.maf(data))
}

## Load file
loadData <- function(url){
  
  if(substr(url, nchar(url)-8, nchar(url)-6) == "maf"){
    data = readMaf(url)
  }else{
    data = readUrl(url, sep = "\t")
  }
  
  return(data)
}

## load data of a dataset
getData <- function(CancerType,DataType){
  ind = getCancerIndex(CancerType)
  
  if(length(DataType) == 1 && toupper(DataType) == "ALL"){
    DataType = ind$OMICS.Dataset 
  }
  
  data = c()
  if(length(DataType) == 1){
    print(paste("Loading", DataType))
    url_ind <- ind$url[toupper(ind$OMICS.Dataset) == toupper(DataType)]
    data = loadData(url_ind)
  }else{
    for (type in DataType){
      url_ind <- ind$url[toupper(ind$OMICS.Dataset) == toupper(type)]
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
