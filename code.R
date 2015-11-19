library(stringdist)
library(stringr)
library(data.table)
tb<-fread(input = 'datafile.txt',stringsAsFactors = T,header = T )
comment<-str_to_lower(tb$FullText)#transfer all letters to lower case
comment<-gsub("[[:punct:]]", " ", comment)
Bank<-c()
for(i in 1:length(comment)){
        contain<-c()
        if('banka' %in% unlist(strsplit(comment[i],split = ' '))){
                contain<-append(contain,1)
        }
        if('bankb' %in% unlist(strsplit(comment[i],split = ' '))){
                contain<-append(contain,2)
        }
        if('bankc' %in% unlist(strsplit(comment[i],split = ' '))){
                contain<-append(contain,3)
        }
        if('bankd' %in% unlist(strsplit(comment[i],split = ' '))){
                contain<-append(contain,4)
        } 
        contain<-paste(contain,collapse = '')
        Bank<-append(Bank,contain)
}#identify which bank
tb<-cbind(tb,Bank)
  
