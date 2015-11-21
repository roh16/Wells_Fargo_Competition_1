library(textcat)

tb<-fread('datafile.txt',stringsAsFactors = F,header = T)
txt<-tb$FullText
txt<-sapply(txt,FUN = function(x){gsub("[^[:alnum:]]", " ",x)})
tb$FullText<-txt
