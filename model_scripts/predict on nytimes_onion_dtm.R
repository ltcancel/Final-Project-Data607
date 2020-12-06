#try predicting real and fake news on target_dtm

#run random forest 
# random forest test

#looking at this website
# https://towardsdatascience.com/random-forest-in-r-f66adf80ec9

library(randomForest)
library(tidyverse)
library(here)

source(here("functions", "perform_random_forest.R"))
source(here("functions", "create_dtm_for_model.R"))

create_dtm_for_model(here('data','csv','new_york_times.csv'), 
                     here('data','csv','onion_dtm_df.csv'), 
                     here('data','csv','nytimes_onion_dtm.csv'))

bi_on <- perform_random_forest(here('data','csv','onion_dtm_df.csv'), 
                           here('data', 'csv','business_insider_onion_dtm.csv'))

cnn_on <- perform_random_forest(here('data','csv','onion_dtm_df.csv'), 
                               here('data', 'csv','cnn_onion_dtm.csv'))
nytimes_on <- perform_random_forest(here('data','csv','onion_dtm_df.csv'), 
                               here('data', 'csv','nytimes_onion_dtm.csv'))
bbt_on <- perform_random_forest(here('data','csv','onion_dtm_df.csv'), 
                               here('data', 'csv','breitbart_onion_dtm.csv'))
atl_on <- perform_random_forest(here('data','csv','onion_dtm_df.csv'), 
                               here('data', 'csv','atlantic_onion_dtm.csv'))
#combine all 5 random forest
bi_on <- bi_on %>%
  mutate(publication = "business_insider")
cnn_on <- cnn_on %>%
  mutate(publication = "cnn")
nytimes_on <- nytimes_on %>%
  mutate(publication = "nytimes")
bbt_on <- bbt_on %>%
  mutate(publication = "breitbart")
atl_on <- atl_on %>%
  mutate(publication = "atlantic")

final <- rbind(bi_on,cnn_on,nytimes_on,bbt_on,atl_on)

final$pred <- as.factor(final$pred)

final <- final %>%
  mutate(pred= ifelse(pred == "Onion", "Fake", "True")) %>%
  mutate(pred_pct= ifelse(pred == "Fake", 0, 1))
  

#final_temp <- final %>%
#  mutate(publication = fct_reorder(publication, desc(mean(pred_pct))))

bi_ft <- perform_random_forest(here('data','csv','output_df.csv'), 
                           here('data', 'csv','business_insider_dtm.csv'))

bi_on <- bi_on %>%
  mutate(model="onion")

bi_on <- bi_on %>%
  mutate(pred= ifelse(pred == "Onion", "Fake", "True"))

bi_ft <- bi_ft %>%
  mutate(model="fake_true")

bi <- rbind(bi_on, bi_ft)

ggplot(bi, aes(x=factor(model), fill=factor(pred) )) +
  geom_bar(position="stack")

ggplot(final, aes(x=factor(publication), fill=factor(pred) )) +
  geom_bar(position="fill") +
  labs(title = "Classification of All Publications")


cnn_on <- perform_random_forest(here('data','csv','onion_dtm_df.csv'), 
                               here('data', 'csv','cnn_onion_dtm.csv'))

cnn_ft <- perform_random_forest(here('data','csv','output_df.csv'), 
                               here('data', 'csv','cnn_dtm.csv'))

cnn_on <- cnn_on %>%
  mutate(model="onion")

cnn_on <- cnn_on %>%
  mutate(pred= ifelse(pred == "Onion", "Fake", "True"))

cnn_ft <- cnn_ft %>%
  mutate(model="fake_true")
cnn <- rbind(cnn_on, cnn_ft)

ggplot(cnn, aes(x=factor(model), fill=factor(pred) )) +
  geom_bar(position="fill" )


breitbart_on <- perform_random_forest(here('data','csv','onion_dtm_df.csv'), 
                                here('data', 'csv','breitbart_onion_dtm.csv'))

breitbart_ft <- perform_random_forest(here('data','csv','output_df.csv'), 
                                here('data', 'csv','breitbart_dtm.csv'))

breitbart_on <- breitbart_on %>%
  mutate(model="onion")

breitbart_on <- breitbart_on %>%
  mutate(pred= ifelse(pred == "Onion", "Fake", "True"))

breitbart_ft <- breitbart_ft %>%
  mutate(model="fake_true")
breitbart <- rbind(breitbart_on, breitbart_ft)

ggplot(breitbart, aes(x=factor(model), fill=factor(pred) )) +
  geom_bar(position="fill" )



#svm test
tune =tune(svm,DocType_c~.,data=train,kernel
           ="radial",scale=FALSE,ranges =list(cost=c(0.001,0.01,0.1,1,5,10,100)))
tune$best.model
#best model gives us the desired cost value
summary(tune)

#plug in the cost value obtained from the summary of the tuning
svm_model =svm(DocType_c~.,data=train,kernel ="radial",cost=10,scale=FALSE)

svm_pred = predict(svm_model,target_dtm)


ggplot(x, aes(x=as.factor(svm_pred) )) +
  geom_bar(color="blue", fill=rgb(0.1,0.4,0.5,0.7) )

