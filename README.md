# Wells_Fargo_Competition

Abstract
Customer voice is a key asset for any company and leveraging it can provide key insights. Twitter and Facebook are key platforms where customers provide feedback on the service they received and thus provides opportunity for a company to understand how they feel about the firm and its services. In this challenge we are tasked with similar opportunity and we have used R and its text mining capabilities to approach this challenge. Like any other data analytics problem the most challenging task was to clean the data and this being text data posed even more challenges. Post the cleaning phase we created corpus of documents which in our cases were tweets and Facebook feeds. Next we applied topic modeling algorithm LDA (Latent Dirichlet allocation) to cluster similar topics.
Keywords
Text mining, topic modeling, Latent Dirchlet Allocation
Deliverable A








    Text Mining
                Our Approach
Data Preparation
We used the tm (text mining) package in R to parse through the text data.  The first step involved usage of various functions to remove the undesirable characters from the data such as punctuations, whitespaces and stop words. We also removed numbers since they were undesirable for our future analysis.
Next we created a corpus of the documents. A sample corpus is attached with the report.


Exploration
After creating the corpus we explored the corpus to examine the sparsity and term length of the corpus. Based on this we removed certain sparse terms from our dataset so that we focus our attention on high frequency terms. After we also examined the highest frequency terms in the corpus.
Clustering Topics using Latent Dirchlet Allocation:
The LDA was developed by David Blei, Andrew Ng, and Michael Jordan and exposed in Blei et al. (2003). LDA creates generative models in general but when used within text mining it creates clusters of topics from text documents. The results of LDA are list of multiple topics. This is advantage of LDA since the user does not set the topics prior to modeling. LDA essentially uses “bag of words” modeling since the sequence of words is not important.
We used the LDA package within R to apply LDA on the corpus we created in the previous step. As an output of LDA we got various clusters of terms.
It is also important to note that the corpus for all the 4 banks was created separately and the outputs obtained from LDA are based on the respective corpuses.
Deliverable B
Since the data comprises of customer conversation on twitter and Facebook. To see the key drivers of the conversations we analyzed the most frequent words in the text data. Following  are the word clouds for all the banks.






Some of the key conversation drivers in general are Goldmansachs,Morganstanley, Wall Street and classwarfare. And a guy whose named Theodwridis is also frequently mentioned in each banks’ topics, so we assume he is a guy who really has something to do with the bank industry.”Get college ready” is also a driver that may have something to do with students account.
Deliverable C
R Script


Also we have attached the code in the submission file.
Deliverable D
Following are the topics for each of the Banks.



Bank A
Financial Inequality
People talk about financial terrorists, wall street, banksters
Goldman Sachs and Morgan Stanley are also being talked about.

Free College Accounts
There are topics related to free college accounts for students and some kind of contest was also organized which might be related to college account

Happy about Loans
People talk opening accounts to pay up the loans,mortgages.



Bank B
Financial Inequality
People talk about financial terrorists, wall street, banksters
Goldman Sachs and Morgan Stanley are also being talked about.

Free College Accounts
There are topics related to free college accounts for students and some kind of contest was also organized which might be related to college account

Carolina Panthers
There are some topics related to Carolina Panthers but also there is mention of fraud

Corporate Settlement
The bank also seems to corporation business and company settlement



Bank C
Global Presence
There are topics in Bank C talking about international business and also mentioned countries such as China and India

Oil trade
Oil and Energy trade is mention is one topic of bank C so we think bank C is more likely to related to natural resources

Financial Inequality
People talk about financial terrorists, wall street, banksters
Goldman Sachs and Morgan Stanley are also being talked about.



Bank D
Financial Inequality
People talk about financial terrorists, wall street, banksters
Goldman Sachs and Morgan Stanley are also being talked about.

Small Business focused
We have 5 out of 10 topics in Bank B dataset talking about small business program and it is quite unique



Deliverable E
Based on the results from lda and FindAssociation function (within tm package) we see that the topic financial inequality where people talk about banks like Morgan Stanley, Goldman Sachs and Wall Street and they also mention words like class warfare, fraudsters. So maybe people are blaming all these banks for inequality and warfare.
Also based on the results we can say that financial inequality is an industry topic since people have referred to it all the conversations involving Bank A, B,C and D.
Bank A and Bank B also seem to provide free accounts to college students. Also it seems that Bank A is also organizing some sort of contest for the college students.
And when we look at specific Banks, Customers at Bank A are happy about getting loans from the bank.
Also Bank B seems to be having some sort of connection with Carolina Panthers and they also support corporate settlements to its customers.
Bank C appears to have international presence in countries like India and China.
Bank D seems to be more small business focused as people have mentioned about in quite a large number of topics we generated using LDA.
