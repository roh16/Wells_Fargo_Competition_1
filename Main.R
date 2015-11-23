library(stringdist)
library(stringr)
library(data.table)
library(dplyr)
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

#subset each bank
badata<-filter(tb,BANKA==1)
bbdata<-filter(tb,BANKB==1)
bcdata<-filter(tb,BANKC==1)
bddata<-filter(tb,BANKD==1)

# The function creating corpus and term frequencies
corpusfun<-function(x){
        library(data.table)
        library(textcat)
        library(tm)
        library(slam)
        
        # omit the special letters in the data
        txt<-x$FullText
        txt<-sapply(txt,FUN = function(y){gsub("[^[:alnum:]]", " ",y)})
        x$FullText<-txt
        dataset<-as.matrix(x)
        #First we will remove retweet entities from the stored tweets (text)
        dataset = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", dataset)
        # Then remove all "@people"
        dataset = gsub("@\\w+", "", dataset)
        # Then remove all the punctuation
        dataset = gsub("[[:punct:]]", "", dataset)
        # Then remove numbers, we need only text for analytics
        dataset = gsub("[[:digit:]]", "", dataset)
        # the remove html links, which are not required for sentiment analysis
        dataset = gsub("http\\w+", "", dataset)
        # finally, we remove unnecessary spaces (white spaces, tabs etc)
        dataset = gsub("[ \t]{2,}", "", dataset)
        dataset = gsub("^\\s+|\\s+$", "", dataset)
        myCorpus = Corpus(VectorSource(dataset))
        myCorpus = tm_map(myCorpus,content_transformer(tolower))
        myCorpus = tm_map(myCorpus, removePunctuation)
        myCorpus = tm_map(myCorpus, removeNumbers)
        myCorpus = tm_map(myCorpus, removeWords, stopwords("english"))
        myDTM = TermDocumentMatrix(myCorpus, control = list(minWordLength = 1))
        ### added this line to allow next step
        m<-rollup(myDTM, 2, na.rm=TRUE, FUN = sum) 
        ###
        m = as.matrix(m)
        v = sort(rowSums(m), decreasing = TRUE)
        names(v)
        a<-row.names(v)
        output<-c(v,a)
        output<-data.frame(output)      
}
# Look at bank a:
corpusA<-corpusfun(x = badata)
corpusB<-corpusfun(x = bbdata)
corpusC<-corpusfun(x = bcdata)
corpusD<-corpusfun(x = bddata)