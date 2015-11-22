library(stringdist)
library(stringr)
library(data.table)
tb<-fread(input = 'datafile.txt',stringsAsFactors = T,header = T )
comment<-str_to_lower(tb$FullText)#transfer all letters to lower case
comment<-gsub("[[:punct:]]", " ", comment)
comment<-as.data.frame(comment)
#creating columns to identify each bank
banka<-apply(comment,1,FUN = function(x)  { if('banka' %in% unlist(strsplit(x,split = ' '))) 1 else 0 })
bankb<-apply(comment,1,FUN = function(x)  { if('bankb' %in% unlist(strsplit(x,split = ' '))) 1 else 0 })
bankc<-apply(comment,1,FUN = function(x)  { if('bankc' %in% unlist(strsplit(x,split = ' '))) 1 else 0 })
bankd<-apply(comment,1,FUN = function(x)  { if('bankd' %in% unlist(strsplit(x,split = ' '))) 1 else 0 })
#bind them to original dataset
tb<-do.call(cbind, list(tb,BANKA=banka,BANKB=bankb,BANKC=bankc,BANKD=bankd))
