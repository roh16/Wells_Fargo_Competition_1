library(stringdist)
library(stringr)
library(data.table)
library(dplyr)
library(tm)
library(topicmodels)
library(SnowballC)
library(rJava)
library(RWeka)
library(slam)
library(textcat)
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

        # omit the special letters in the data
        txt<-x$FullText
        txt<-sapply(txt,FUN = function(y){gsub("[^[:alnum:]#]", " ",y)})
        x$FullText<-txt
        dataset<-x$FullText
        #First we will remove retweet entities from the stored tweets (text)
        dataset = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", " ", dataset)
        # Then remove all "@people"
        dataset = gsub("@\\w+", " ", dataset)
        # Then remove all the punctuation
        dataset = gsub("[[:punct:,^\\#]]", " ", dataset)
        # Then remove numbers, we need only text for analytics
        dataset = gsub("[[:digit:]]", " ", dataset)
        # the remove html links, which are not required for sentiment analysis
        dataset = gsub("http\\w+", " ", dataset)
        # finally, we remove unnecessary spaces (white spaces, tabs etc)
        dataset = gsub("[ \t]{2,}", " ", dataset)
        dataset = gsub("^\\s+|\\s+$", "", dataset)
        
        print('gsubs finished')
        

        myCorpus = Corpus(VectorSource(dataset))
        
        myCorpus <- tm_map(myCorpus,content_transformer(function(x) iconv(x, to='UTF-8-MAC', sub='byte')))
        
        myCorpus = tm_map(myCorpus, content_transformer(tolower))
        myCorpus = tm_map(myCorpus, content_transformer(removeNumbers))
        myCorpus = tm_map(myCorpus, content_transformer(removePunctuation))
        myCorpus = tm_map(myCorpus, content_transformer(removeWords), stopwords('english'))
        myCorpus = tm_map(myCorpus, content_transformer(removeWords),c('banka','bankb','bankc','bankd','bank','hndl','twit','lol','hey','make','name','don','bit','uhijre'))
        #another stopwords list
        stop2<-as.vector(stopwords('SMART'))
        # strip "'" in the list to because people always do this in their tweets
        stop3<-sapply(stop2,FUN = function(x){gsub(pattern = "'",'',x)})
        myCorpus = tm_map(myCorpus, content_transformer(removeWords),c(stop2,stop3))    
        myCorpus <- tm_map(myCorpus, content_transformer(stripWhitespace))
        myCorpus <- tm_map(myCorpus, content_transformer(PlainTextDocument))
        corpus <- tm_filter(
                myCorpus,
                FUN = function(doc) !is.element(meta(doc)$id, empty.rows))
     
   
        
     
       

   ####################################################Topic Modeling############ 
         print('creating dtm')
         dtm<-DocumentTermMatrix(myCorpus)
         dtm   <- dtm[row_sums(dtm)>0, ] 
   

         SEED = sample(1:1000000, 1)
         k = 10 
         print('Modeling')
         models <- list(
           CTM       = CTM(dtm, k = k, control = list(seed = SEED, var = list(tol = 10^-4), em = list(tol = 10^-3))),
           VEM       = LDA(dtm, k = k, control = list(seed = SEED)),
           VEM_Fixed = LDA(dtm, k = k, control = list(estimate.alpha = FALSE, seed = SEED)),
           Gibbs     = LDA(dtm, k = k, method = "Gibbs", control = list(seed = SEED, burnin = 1000,
                                                                        thin = 100,    iter = 1000))
   )
   lapply(models, terms, 10)
         
 
}
# Look at bank a:
corpusA<-corpusfun(x = badata)
corpusB<-corpusfun(x = bbdata)
corpusC<-corpusfun(x = bcdata)
corpusD<-corpusfun(x = bddata)