library(dplyr)

#' Title
#'
#' @param Mutation 
#' @param num_genes 
#'
#' @return
#' @export
#'
#' @examples
topMutatedGene <- function(Mutation, num_genes = 1){
  
  info = c()
  gene = sort(apply(Mutation, 1, sum),decreasing = TRUE)[1:num_genes]
  num.mutation = as.integer(gene)
  geneID = names(gene)
  perc = (as.integer(gene)/ncol(Mutation))*100
  info = data.frame(geneID,num.mutation,perc)
  return(info)
}

getPatientsWithMutation <- function(Mutation,geneID){
  
  patients = colnames(Mutation[,Mutation[rownames(Mutation)==geneID,]>0])
  return(patients)
}


#' Title
#'
#' @param RNAseq 
#' @param Mutation 
#' @param gene_name 
#'
#' @return
#' @export
#'
#' @examples
subsetSharedFetures <- function(RNAseq,Mutation, gene_name){
  
  patients = getPatientsWithMutation(Mutation, gene_name)
  subsetCol = colnames(RNAseq) %in% patients
  
  return(RNAseq[,subsetCol])
}
