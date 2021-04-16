library(ggplot2)
library(ggrepel)

#' Get top mutated genes
#'
#' Return list of genes more mutated
#'
#' @param Mutation 
#' @param num_genes 
#'
#' @return
#' @export
#'
#' @examples
topMutatedGenes <- function(Mutation, num_genes = 30){
  
  gene = sort(apply(Mutation, 1, sum),decreasing = TRUE)[1:num_genes]
  num.mutation = as.integer(gene)
  geneID = names(gene)
  perc = (as.integer(gene)/ncol(Mutation))*100
  info = data.frame(geneID,num.mutation,perc)
  return(info)
}

#' Get genes without mutations
#'
#' Return list of genes not mutated
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


#' Get omics data with shared mutation
#'
#' Subset omics data with shared mutation
#'
#' @param Data 
#' @param Mutation 
#' @param gene_name 
#'
#' @return
#' @export
#'
#' @examples
subsetSharedMutation <- function(Data,Mutation, gene_name){
  
  patients = getPatientsWithMutation(Mutation, gene_name)
  subsetCol = colnames(Data) %in% patients
  
  return(Data[,subsetCol])
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


#' convertEnsambleToSymbol
#
#' @param gene_list 
#'
#' @return
#' @export
#'
#' @examples
convertEnsambleToSymbol <- function(gene_list){

  gene_list <- rownames(rnaseq_tum)
  
  edb <- getEnsDbHsapiens()

  gene_IDs2 <- data.frame(gene_name = substr(gene_list,1,15))
  gene_IDs1 <- data.frame(gene_name = edb$gene_name, geneID = edb$gene_biotype)
  gene_ID <- left_join(gene_IDs2,gene_IDs1)

  return(gene_ID)

}

#' Plot correlation
#'
#' Plot correlation of genes between different omics data
#'
#' @param dataOmics1 
#' @param dataOmics2 
#'
#' @return
#' @export
#'
#' @examples
plotCorrelation <- function(dataOmics1, dataOmics2){
  
  inter_genes <- intersect(rownames(dataOmics1),rownames(dataOmics2))
  inter_samples <- intersect(colnames(dataOmics1),colnames(dataOmics2))
  
  df <- data.frame()
  for (gene in inter_genes){
    prot_gene <- as.numeric(dataOmics1[gene,inter_samples])
    rna_gene <- as.numeric(dataOmics2[gene,inter_samples])
    if(!(any(is.na(rna_gene)) | any(is.na(prot_gene)) )){
      res <- cor.test(prot_gene,rna_gene, method = "spearman", exact = FALSE)
      df[gene,"pval"] <- res$p.value
      df[gene,"rho"] <- res$estimate
    }
    
  }

  p_val = as.numeric(unlist(df["pval"]))
  p_val[p_val==0] <- (10^-1)*min(p_val[p_val!=0])
  rho = as.numeric(unlist(df["rho"]))
  
  df2 <- data.frame(pval = -log10(p_val), rho = rho, geneID = rownames(df))
  
  return(ggplot(df2, aes(x=rho, y=pval, label = geneID)) + 
    geom_point() + 
    geom_text_repel(data=df2[order(df2$pval,df2$rho, decreasing = c(TRUE,FALSE)),][1:10,], aes(x=rho, y=pval, label = geneID),  colour = "blue") +
    geom_text_repel(data=df2[order(df2$pval,df2$rho, decreasing = c(FALSE,TRUE)),][1:10,], aes(x=rho, y=pval, label = geneID),  colour = "red") +
    geom_text_repel(data=df2[order(df2$rho),][1:2,], aes(x=rho, y=pval, label = geneID),  colour = "red") + 
    ggtitle("Correlation Plot") + 
    ylab(" -log (p-value)") + 
    theme_bw())

}

