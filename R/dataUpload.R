library(htmltab)
library(dplyr)
library(tidyr)

library(rdrop2)
drop_auth()

token <- drop_auth()
saveRDS(token, file = "token.rds")

scraplinks <- function(url){
  # Create an html document from the url
  webpage <- xml2::read_html(url)
  # Extract the URLs
  url_ <- webpage %>%
    rvest::html_nodes("a") %>%
    rvest::html_attr("href")
  # Extract the link text
  link_ <- webpage %>%
    rvest::html_nodes("a") %>%
    rvest::html_text()
  return(tibble(link = link_, url = url_))
}

localroot_path = "/Users/antonio/Dropbox/"
pathDrop = "Work/CPTAC_biolinks/CPTAC_data/"
root <- "http://linkedomics.org"
root.download <- file.path(root,"data_download")
linkedOmics <- htmltab(paste0(root,"/login.php#dataSource"))
linkedOmics <- linkedOmics %>% unite(col = "download_page","Cohort Source","Cancer ID", remove = FALSE,sep = "-")

data_omics <- lapply(linkedOmics$download_page[1:3], function(download_page){
  url <- file.path(root.download,download_page)
  down_urls <- scraplinks(url)
  cbind(htmltab(url),down_urls[down_urls$link == "Download",][,2])
})
names(data_omics) <- linkedOmics$download_page[1:3]

names = "CPTAC-COAD"
ind = which(linkedOmics$download_page==names)

data_omics <- lapply(linkedOmics$download_page[ind], function(download_page){
  url <- file.path(root.download,download_page)
  down_urls <- scraplinks(url)
  cbind(htmltab(url),down_urls[down_urls$link == "Download",][,2])
})
names(data_omics) <- linkedOmics$download_page[ind]

data_omics_drop <- data_omics

pathCancer = paste0(pathDrop,names)
drop_create(pathCancer)

for (i in 1:nrow(data_omics[[names]])){
  
  down_url = data_omics[[names]]$url[i]
  
  filename = paste0(data_omics[[names]]$`OMICS Dataset`[i],".",data_omics[[names]]$`File type`[i])
  download.file(down_url, paste0(localroot_path, pathCancer, "/",filename), method = "curl", mode = "wb")
  
  Sys.sleep(14)
  
  link = drop_share(paste0(pathCancer, "/",filename))
  link = paste0(substr(link$url,1,nchar(link$url)-4),"raw=1")  
  
  data_omics_drop[[names]]$url[i] = link
}

write.csv(data_omics_drop[[names]], file = paste0(localroot_path, pathCancer,"/",names,".csv"), row.names = FALSE)

#drop_upload(paste0(names,".csv"), path = pathCancer)
link = drop_share(paste0(pathCancer,"/",names,".csv"))
link = paste0(substr(link$url,1,nchar(link$url)-4),"raw=1")         
print(link)