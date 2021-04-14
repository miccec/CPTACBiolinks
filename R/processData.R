library(dplyr)
library(ComplexHeatmap)

#' Title
#'
#' @param Mutation 
#' @param num_genes 
#'
#' @return
#' @export
#'
#' @examples
topMutatedGene <- function(Mutation, num_genes = 30){
  
  gene = sort(apply(Mutation, 1, sum),decreasing = TRUE)[1:num_genes]
  num.mutation = as.integer(gene)
  geneID = names(gene)
  perc = (as.integer(gene)/ncol(Mutation))*100
  info = data.frame(geneID,num.mutation,perc)
  return(info)
}

#' #Get genes without mutations
#'
#' @param Mutation 
#'
#' @return
#' @export
#'
#' @examples
notMutatedGene <- function(Mutation){

  gene = apply(Mutation, 1, sum)
  geneNonMut = gene[gene==0]
  geneID = names(geneNonMut)
  info = data.frame(geneID)
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

#' Plot mutations
#'
#' Heatmap mutations or oncoplot of annotated mutations
#'
#' @param Mutation 
#' @param top 
#'
#' @return
#' @export
#'
#' @examples
plotMutations <- function(Mutation, top = 30){
  
  if(class(Mutation) == "MAF"){
    return(maftools::oncoplot(Mutation, top))
  }else{
  removeGene <- rowSums(Mutation)==0
  Mutation <- Mutation[!removeGene,]
  
  ord <- order(rowSums(Mutation), decreasing = TRUE)
  Mutation <- Mutation[ord[1:top],]
  
  return(pheatmap::pheatmap(Mutation, cluster_rows = TRUE, cluster_cols = TRUE, color = c("gray", "red"), legend = FALSE))
  }
}



