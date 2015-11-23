corpusfun<-function(x){
        library(data.table)
        library(textcat)
        library(tm)
        library(slam)
        
        # omit the special letters in the data
        txt<-x$FullText
        txt<-sapply(txt,FUN = function(x){gsub("[^[:alnum:]]", " ",x)})
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



















