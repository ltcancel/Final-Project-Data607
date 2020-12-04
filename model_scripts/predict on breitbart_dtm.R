#try predicting real and fake news on nytimes_dtm

#run random forest 
# random forest test

#looking at this website
# https://towardsdatascience.com/random-forest-in-r-f66adf80ec9

library(randomForest)
library(tidyverse)
library(here)



df <- read_csv(here('data','csv','output_df.csv'))
breitbart_dtm<-read_csv(here('data','csv','breitbart_dtm.csv'))
#rename type column, get rid of doc it
df<-df%>%
  select(-docId)
df$DocType <- as.factor(df$DocType)


colnames(df) <- paste(colnames(df), 'c', sep="_")


#already randomly assigned spam or ham so I can just divide into train and test
#70% train
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

model <- randomForest(DocType_c~.,data=train,mtry=2,importance
                      =TRUE,proximity=TRUE)
model
pred <- predict(model, newdata=test[-num_cols],type="class")



#add _c
colnames(breitbart_dtm) <- paste(colnames(breitbart_dtm), 'c', sep="_")

pred <- predict(model, newdata=breitbart_dtm,type="class")

x<-as.data.frame(pred)
is.factor(x$pred)

ggplot(x, aes(x=as.factor(pred) )) +
  geom_bar(color="blue", fill=rgb(0.1,0.4,0.5,0.7) )


#svm test

svm_pred = predict(svm_model,breitbart_dtm)


ggplot(x, aes(x=as.factor(svm_pred) )) +
  geom_bar(color="blue", fill=rgb(0.1,0.4,0.5,0.7) )
0
