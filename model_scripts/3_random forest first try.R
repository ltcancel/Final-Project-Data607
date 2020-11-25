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



#SVM MODEL


library(e1071)
library(kernlab)
view(train)

tune =tune(svm,DocType_c~.,data=train,kernel
           ="radial",scale=FALSE,ranges =list(cost=c(0.001,0.01,0.1,1,5,10,100)))
tune$best.model
#best model gives us the desired cost value
summary(tune)

#plug in the cost value obtained from the summary of the tuning
svm_model =svm(DocType_c~.,data=train,kernel ="radial",cost=10,scale=FALSE)
svm_pred = predict(svm_model,test)


#confusion matrix for SVM model
cm <- table(unlist(test[,num_cols]), unlist(pred))
caret::confusionMatrix(unlist(pred), unlist(test[,num_cols]))

#scatter plot of the model
?plot.svm
?svm

#trying to plot using plot.svm but we need to specify a formula?
plot(svm_model, data = train, subject_c ~ email_c)

#KSVM model and plot
ksvm_model = ksvm(DocType_c~.,data=train, type = "C-svc")

# get error
# can only be used if you have 2 columns
plot(ksvm_model, data = train)

#returns a separate plot for each column in train
kernlab::plot(DocType_c~.,data=train, grid = 50)

