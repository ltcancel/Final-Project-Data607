library(tidyverse)
getwd()
#i know theres a better way to get files directly from kaggle that involves logging in 

#address where data is located
https://www.kaggle.com/snapcrack/all-the-news?select=articles1.csv


setwd("c:\\data\\git_data\\data")
dat<-read.csv("articles1.csv")



dat<-sample_n(dat,10000)

#check if factor
is.factor(dat$publication)

#set publication as factor

dat$publication<-as.factor(dat$publication)

#split into tables by publication

df_list<-dat%>%
  group_split(publication)

#how to access a table inside the list
#view(df_list[[1]])

#create names for the tables and str_replace the spaces for ease of use
publications<-as.list(tolower(str_replace_all(levels(dat$publication)," ","_")))

#change names of tables
names(df_list)<-publications


#accesing tables inside of df_list example
#names(df_list)
#df_list$new_york_times


#tidying data for analysis


#set each list item to its own data frame under its name
for (i in 1:length(df_list)){
  #load df into temp variable
  temp<-df_list[[i]]%>%
    select("doc_id"=id,"text"=content) #selected just the id and content, i think thats all we need
  #assigns data frame in temp to name of the data frame
  assign(names(df_list[i]),temp)
}

#example output
#view(head(breitbart))

#data is ready to be turned into a corpus

#write csv for each publication

#atlantic
con<-file(here('data','csv','atlantic.csv'),encoding="UTF-8")
write.csv(atlantic,file=con , row.names = FALSE, )
#breitbart
con<-file(here('data','csv','breitbart.csv'),encoding="UTF-8")
write.csv(atlantic,file=con , row.names = FALSE, )
#business_insider
con<-file(here('data','csv','business_insider.csv'),encoding="UTF-8")
write.csv(business_insider,file=con , row.names = FALSE, )
#cnn
con<-file(here('data','csv','cnn.csv'),encoding="UTF-8")
write.csv(cnn,file=con , row.names = FALSE, )
#new_york_times
con<-file(here('data','csv','new_york_times.csv'),encoding="UTF-8")
write.csv(new_york_times,file=con , row.names = FALSE, )


