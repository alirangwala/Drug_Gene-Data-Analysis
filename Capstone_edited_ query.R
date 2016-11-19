library(openxlsx)
library(rentrez)
interactions<-read.delim('interactions.tsv', header=T)

product<-read.xlsx('OBDataFiles.xlsx',sheet=1,startRow = 1, colNames = TRUE,rowNames = FALSE)
exclusivity<-read.xlsx('OBDataFiles.xlsx',sheet=2,startRow = 1, colNames = TRUE,rowNames = FALSE)
patent<-read.xlsx('OBDataFiles.xlsx',sheet=3,startRow = 1, colNames = TRUE, rowNames = FALSE)
duplicated(interactions$entrez_gene_symbol) & duplicated(interactions$drug_primary_name)
un_inter<-interactions[!duplicated(paste(interactions$entrez_gene_symbol,interactions$drug_primary_name)),]

search<-paste(paste("'",un_inter$entrez_gene_symbol,"'",sep=''), "AND", paste("'",un_inter$drug_primary_name,"'", sep=""),sep=" ")
search
search_count<-matrix(ncol=1, nrow=length(search))
for(i in 1:length(search)){
  search_count[i,1]<-entrez_search(db="pubmed", term=search[i], retmax=0)$count
  i=1+i}

#Search with double Quotes
search<-paste(dQuote(un_inter$entrez_gene_symbol), "AND", dQuote(un_inter$drug_primary_name), sep=" ")
search



#Creating (drug name, gene name, # of publications, z score) table
search_cnt<-matrix(ncol=2, nrow=length(search))

for(i in 1:length(search)){
  search_cnt[i,2]<- -1
  i=i+1
}

#Marks matrix where the for loop for plugging stops working
for(i in 1:length(search)){
  if(search_cnt[i,2]!=-1)
    i=i+1
  else{not_neg_one<- i
  break()
  }
}
not_neg_one 

#Chugging for loop
for(i in not_neg_one:length(search)){
  search_cnt[i,1]<-search[i]
  search_cnt[i,2]<-entrez_search(db="pubmed", term=search[i], retmax=0)$count
  i=1+i
  if(i%%100==0) {
    Sys.sleep(3)}
}






for(i in 1803:length(search)){
  search_count[i]<-entrez_search(db="pubmed", term=search[i], retmax=0)$count
  i=i+1
  if(i%%150==0) {
    Sys.sleep(3)}
}
#Get mean and stdev of unique drug and gene pairs for zscore

mean(as.numeric(searchdf[!duplicated(searchdf$V1),]$V2))

#papers<-lapply(search,entrez_search(db="pubmed", term=x, retmax=0))
entrez_search(db="pubmed", term=search[540], retmax=0)$count

#Data mining from HTML
tablesite<-paste(readLines("/Users/alirangwala/Desktop/Level_Bootcamp_Files/Capstone/MedWatch - January 2007 Safety-Related Drug Labeling Changes - Summary.htm"), collapse="\n")