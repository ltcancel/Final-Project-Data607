

## libraries

library(tm)
library(tidyverse)
#here helps us deal with paths in markdowns.
library(here)


#data frame to corpus

new_york_times_df <-read.csv(here('data','csv','new_york_times.csv'), encoding="ascii")




#The full data is too big to be processed, so we sample the df to get a mix of ham and spam


#sample_df<-as.data.frame(slice_sample(full_df,n=500))
Encoding(new_york_times_df$text) <- "latin1"
new_york_times_df$text<-iconv(new_york_times_df$text, "latin1", "ASCII", sub="")

sample_df<-new_york_times_df

#we can add filters here to remove punctuation and stuff (in data mining notes in resources folder)

spamham_corpus<-Corpus(DataframeSource(sample_df))
#add filtering here to get rid of whitespace, stopwords etc..

#POTENTIAL FILTERS (maybe we dont want them?)
#remove stopwords
spamham_corpus<-tm_map(spamham_corpus, removeWords, stopwords("english"))
#strip white space
spamham_corpus<-tm_map(spamham_corpus, stripWhitespace)
#convert to lower
spamham_corpus<-tm_map(spamham_corpus, content_transformer(tolower))
#url remover
#urlRemover <- function(x) gsub("http:[[:alnum:]]*","", x)
#spamham_corpus<-tm_map(spamham_corpus,content_transformer(urlRemover))
#email remover
#emailRemover<-function(x) str_replace(x,"(?<=\\s)[[:alnum:]._-]+@[[:alnum:],.-]{2,}","")
#spamham_corpus<-tm_map(spamham_corpus,content_transformer(emailRemover))

#remove numbers
spamham_corpus<-tm_map(spamham_corpus, removeNumbers)
#punctuation remover
spamham_corpus<-tm_map(spamham_corpus, removePunctuation)

#stemming (simplest word form)
spamham_corpus<-tm_map(spamham_corpus, stemDocument)



## create document term matrix from corpus and recombine

#create document term matrix
dtm<-DocumentTermMatrix(spamham_corpus)

#removing sparse variables
dtm <- removeSparseTerms(dtm, 0.96)

#turn into data frame
dataset <- as.data.frame(as.matrix(dtm))

# note that the "doc_id" column and the rownumber match, so the correct tags have been re added

#join the doc_id and type columns to the main dataset
nrow(dataset)
nytimes_dtm<-cbind("docId"=sample_df$doc_id,dataset)


#load df that model is created with
df <- read_csv(here('data','csv','output_df.csv'))
#run format_dtm() on nytimes_dtm MAKE SURE TO DO before YOU RUN THE MODEL, you add "_c" to all the colnames and it wont work

nytimes_dtm<-format_dtm(nytimes_dtm,df)

#ncol(nytimes_dtm)
con<-file(here('data','csv','nytimes_dtm.csv'),encoding="UTF-8")
write.csv(nytimes_dtm,file=con , row.names = FALSE, )



