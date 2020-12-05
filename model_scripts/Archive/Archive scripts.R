#SVM MODEL


library(e1071)
library(kernlab)
#view(train)

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
#?plot.svm
#?svm

#trying to plot using plot.svm but we need to specify a formula?
plot(svm_model, data = train, subject_c ~ email_c)

#KSVM model and plot
ksvm_model = ksvm(DocType_c~.,data=train, type = "C-svc")

# get error
# can only be used if you have 2 columns
plot(ksvm_model, data = train)

#returns a separate plot for each column in train
kernlab::plot(DocType_c~.,data=train, grid = 50)