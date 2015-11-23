library(NLP)
library(tm)
library(RColorBrewer)
library(wordcloud)
library(topicmodels)
library(SnowballC)





# Now for Topic Modeling

# Get the lengths and make sure we only create a DTM for tweets with
# some actual content
doc.lengths <- rowSums(as.matrix(DocumentTermMatrix(corpus)))
dtm <- DocumentTermMatrix(corpus[doc.lengths > 0])
# model <- LDA(dtm, 10)  # Go ahead and test a simple model if you want



# Now for some topics
SEED = sample(1:1000000, 1)  # Pick a random seed for replication
k = 10  # Let's start with 10 topics

# This might take a minute!
models <- list(
  CTM       = CTM(dtm, k = k, control = list(seed = SEED, var = list(tol = 10^-4), em = list(tol = 10^-3))),
  VEM       = LDA(dtm, k = k, control = list(seed = SEED)),
  VEM_Fixed = LDA(dtm, k = k, control = list(estimate.alpha = FALSE, seed = SEED)),
  Gibbs     = LDA(dtm, k = k, method = "Gibbs", control = list(seed = SEED, burnin = 1000,
                                                               thin = 100,    iter = 1000))
)



# There you have it. Models now holds 4 topics. See the topicmodels API documentation for details

# Top 10 terms of each topic for each model
# Do you see any themes you can label to these "topics" (lists of words)?
lapply(models, terms, 10)

# matrix of tweet assignments to predominate topic on that tweet
# for each of the models, in case you wanted to categorize them
assignments <- sapply(models, topics) 
