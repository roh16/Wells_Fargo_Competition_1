library(data.table)
library(textcat)
library(tm)
library(slam)

# read the data first:
#tb<-fread('datafile.txt',stringsAsFactors = F,header = T)
#tb<-fread('./Data.txt',stringsAsFactors = F,header = T)

# omit the special letters in the data
txt<-tb$FullText
txt<-sapply(txt,FUN = function(x){gsub("[^[:alnum:]]", " ",x)})
tb$FullText<-txt


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

myCorpus = Corpus(VectorSource(tb))
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


