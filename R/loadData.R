START_INDEX = "https://dl.dropbox.com/s/ofxteh9ovmftcqf/index.csv"
library(maftools)

## Read ulr as table
readUrl <- function(url, sep = ",", rownames = 0){
  
  #if(substr(url,nchar(url)-7,nchar(url)-6) == "gz"){
  #  url_ind <- textConnection(readLines(gzcon(url(url)), warn=FALSE))
  #} else{
  #  url_ind <- url(url) 
  # }
  
  #if(rownames>0){
  #  ind = read.table(url_ind,sep = sep, header = TRUE, row.names = rownames, stringsAsFactors = FALSE)
  #}else{
  #  ind = read.table(url_ind,sep = sep, header = TRUE, stringsAsFactors = FALSE)
  #}
  
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

## Get datasets index (list user)
#' Title
#'
#' @return
#' @export
#'
#' @examples
getDatasetsList <- function(){
  
  ind = getStartIndex()
  print("Avaiable datasets:")
  return(ind[,1:2])
}

getCancerIndex <- function(CancerType){
  
  ind = getStartIndex()
  url_ind <- ind$Data_link[toupper(ind$Dataset_name) == toupper(CancerType)]
  
  ind = readUrl(url_ind)
  return(ind)
}

## Get index of a dataset (list user)
#' Title
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
  return(ind[,1])
}

readMaf <- function(url){

  if(substr(url,nchar(url)-7,nchar(url)-6) == "gz"){
    filename <- "mutation.maf.gz"
  } else{
    filename <- "mutation.maf"
  }
  
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
  
  if(substr(url, nchar(url)-8, nchar(url)-6) == "maf" | substr(url, nchar(url)-11, nchar(url)-9) == "maf"){
    data = readMaf(url)
  }else{
    data = readUrl(url, sep = "\t", rownames = 1)
  }
  
  return(data)
}

## load data of a dataset
#' Title
#'
#' @param CancerType 
#' @param DataType 
#'
#' @return
#' @export
#'
#' @examples
getData <- function(CancerType,DataType){
  
  ind = getCancerIndex(CancerType)
  
  if(length(DataType) == 1 && toupper(DataType) == "ALL"){
    DataType = ind$OMICS_Dataset 
  }
  
  data = c()
  if(length(DataType) == 1){
    print(paste("Loading", DataType))
    url_ind <- ind$url[toupper(ind$OMICS_Dataset) == toupper(DataType)]
    data = loadData(url_ind)
  }else{
    for (type in DataType){
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

