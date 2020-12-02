#try predicting real and fake news on target_dtm

#run random forest 
# random forest test

#looking at this website
# https://towardsdatascience.com/random-forest-in-r-f66adf80ec9

library(randomForest)
library(tidyverse)
library(here)

perform_random_forest <- function( base_dtm, 
                                   target_dtm) { 
  df <- read_csv(base_dtm)
  target_dtm<-read_csv(target_dtm)
  #rename type column, get rid of doc it
  df<-df%>%
    select(-docId)
  df$DocType <- as.factor(df$DocType)
  
  colnames(df) <- paste(colnames(df), 'c', sep="_")
  
  #already randomly assigned spam or ham so I can just divide into train and test
  #70% trai
  num_rows <- nrow(df)
  first_rows <- round(num_rows*.70)
  next_rows <- first_rows + 1
  
  train<-df[1:first_rows,]
  #30% test
  test<-df[next_rows:num_rows,]
  
  num_cols <- ncol(df)
  #initialize randomForest class
  
  #randomForest() function not running. I think it might be something to do with non ASCII
  #characters in the column names??
  
  model <- randomForest(DocType_c~.,data=train,importance
                        =TRUE,proximity=TRUE)
  
  #add _c
  colnames(target_dtm) <- paste(colnames(target_dtm), 'c', sep="_")
  
  pred <- predict(model, newdata=target_dtm,type="class")
  
  x<-as.data.frame(pred)
  return(x)
}