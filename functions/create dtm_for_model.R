
## libraries

library(tm)
library(tidyverse)
#here helps us deal with paths in markdowns.
library(here)

source(here("functions","format_dtm", "format_dtm.R"))


create_dtm_for_model <- function( source_csv, 
                                  comparison_dtm, 
                                  output_file) { 
  #data frame to corpus
  source_df <-read.csv(source_csv, encoding="ascii")
  
  Encoding(source_df$text) <- "latin1"
  source_df$text<-iconv(source_df$text, "latin1", "ASCII", sub="")
  
  sample_df<-source_df
  
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
  output_dtm<-cbind("docId"=sample_df$doc_id,dataset)
  
  #load df that model is created with
  df <- read_csv(comparison_dtm)
  #run format_dtm() on output_dtm MAKE SURE TO DO before YOU RUN THE MODEL, you add "_c" to all the colnames and it wont work
  
  output_dtm<-format_dtm(output_dtm,df)
  
  #ncol(output_dtm)
  con<-file(output_file,encoding="UTF-8")
  write.csv(output_dtm,file=con , row.names = FALSE, )
}

