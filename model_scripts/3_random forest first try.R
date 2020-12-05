# random forest test

#looking at this website
# https://towardsdatascience.com/random-forest-in-r-f66adf80ec9

library(randomForest)
library(tidyverse)
library(here)



df <- read_csv(here('data','csv','output_df.csv'))

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

df2<-rename(df2,Type=Type_c)

cm <- table(unlist(test[,num_cols]), unlist(pred))

caret::confusionMatrix(unlist(pred), unlist(test[,num_cols]))

