library(tidyverse)
library(here)

df <- read_csv(here('data','csv','output_df.csv'))
nyt<-read_csv(here('data','csv','nytimes_dtm.csv'))
temp<-remove_dtm(nyt,df)

ncol(temp)
ncol(df)
view(colnames(temp))
view(colnames(df))

temp<-format_dtm(nyt,df)

ncol(temp)
ncol(df)

view(colnames(temp))
view(colnames(df))

a<-"asdfjkl"

pattern<-paste0("^",a,"$")
all(str_detect(colnames(df),pattern,negate=TRUE))
