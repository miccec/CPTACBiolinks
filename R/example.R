setwd("~/Dropbox (Personal)/Umiami2020/CPTAC2020")
library(TCGAbiolinks)
require(SummarizedExperiment)

projects <- TCGAbiolinks:::getGDCprojects()$project_id
projects <- projects[grepl('^TCGA',projects,perl=T)]
projects <- "CPTAC-3"
projects <- sort(projects)

for ( i in 1: length(projects)){
  
  curTumor <- projects[i]
  print(paste(i, "_", curTumor))
  query <- GDCquery(project = curTumor,
                    data.category = "Transcriptome Profiling",
                    data.type = "Gene Expression Quantification",
                    workflow.type = "HTSeq - FPKM-UQ")
  GDCdownload(query,
              directory = "./HTSeq")
  
  counts <- GDCprepare(query,
                       directory = "./HTSeq",
                       summarizedExperiment = F)
  counts <- as.data.frame(counts)
  
  save(dataPrep, geneDf,
       file = paste0("./HTseq_FPKM_UQ/",gsub("-","_",curTumor),
                     "_HTSeq_FPKM_UQ.Rdata"))
  
}


getLinkedOmicsData <- function(project, dataset){
  
  tab <- get(data("linkedOmics.data",package = "TCGAbiolinksGUI.data", envir = environment()))
  
  if(missing(project) || !project %in% tab$project){
    print(knitr::kable(data.frame("Avail projects" = tab$project %>% unique())))
    stop("Project not found! Possible list is above")
  }
  tab <- tab %>% dplyr::filter(.data$project == !!project)
  
  if(missing(dataset) || !dataset %in% tab$`OMICS Dataset`){
    print(knitr::kable(data.frame("Avail dataset" = tab$`OMICS Dataset` %>% unique())))
    stop("dataset not found! Possible list is above")
  }
  tab <- tab %>% dplyr::filter(.data$`OMICS Dataset` == !!dataset)
  url <- tab %>% pull("url")
  readr::read_tsv(url,col_types = readr::cols())
}


getLinkedOmicsData("CPTAC-UCEC"," Proteome (Gene level) ")
