setwd('C:\\Users\\admin\\Desktop\\Wells_Fargo_Competetion')
library(data.table)
tb<-fread('./Data.txt',stringsAsFactors = F,header = T)
tb<-as.matrix(tb)
#First we will remove retweet entities from the stored tweets (text)
tb = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", tb)
# Then remove all "@people"
tb = gsub("@\\w+", "", tb)
# Then remove all the punctuation
tb = gsub("[[:punct:]]", "", tb)
# Then remove numbers, we need only text for analytics
tb = gsub("[[:digit:]]", "", tb)
# the remove html links, which are not required for sentiment analysis
tb = gsub("http\\w+", "", tb)
# finally, we remove unnecessary spaces (white spaces, tabs etc)
tb = gsub("[ \t]{2,}", "", tb)
tb = gsub("^\\s+|\\s+$", "", tb)
library(tm)
myCorpus = Corpus(VectorSource(tb))
myCorpus = tm_map(myCorpus, tolower)
myCorpus = tm_map(myCorpus, removePunctuation)
myCorpus = tm_map(myCorpus, removeNumbers)
myCorpus = tm_map(myCorpus, removeWords, stopwords("english"))

myDTM = TermDocumentMatrix(myCorpus, control = list(minWordLength = 1))

m = as.matrix(myDTM)

v = sort(rowSums(m), decreasing = TRUE)
names(v)
a<-row.names(v)
output<-c(v,a)s
output<-data.frame(output)


