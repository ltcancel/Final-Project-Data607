#libraries 
library(rvest)
library(stringr)
library(tidyverse)

#onion main URL
url <-("https://www.theonion.com/latest")

onion <- read_html(url)

#nodes to use in loop

#article title
onion %>%
  html_nodes(".eXwNRE") %>%
  html_text()

#article links
onion %>%
  html_nodes(".aoiLP") %>%
  html_nodes(".js_link") %>%
  html_attr("href") %>%
  as.character()


#article 1
url1 <- ("https://www.theonion.com/cdc-shuts-down-thanksgiving-travel-by-carrying-out-simu-1845719500")

pg1 <- read_html(url)

#article title
url %>%
  html_nodes(".bBLibw") %>%
  html_text()

#article publish date and time
pg1 %>%
  html_nodes(".gWMcOL") %>%
  html_attr("datetime") %>%
  as.character()

#article text
pg1 %>%
  html_nodes(".js_post-content") %>%
  html_text()
  

#other pages
str1 <- "pg"
pg1 <- ("https://www.theonion.com/latest")
pg2 <- ("?startTime=1606136700715")
pg3 <- ("https://www.theonion.com/latest?startTime=1605816000526")
pg4 <- ("https://www.theonion.com/latest?startTime=1605705780724")
pg5 <- ("https://www.theonion.com/latest?startTime=1605539700275")
pg6 <- ("https://www.theonion.com/latest?startTime=1605204000944")


#max number of pages
max <- 6
#iterating the link function
base_url<-"https://www.theonion.com/tag/archive?startIndex="
iterate_onion_url<-function(max,base_url){
  link_list<-list()
  for(i in 0:max){
    pagenum<-20*i
    temp<-paste0(base_url,as.character(pagenum))
    link_list<-c(link_list,temp)
  }
  return(link_list)
}

#function

for (i in 1:max){
  url <- str_c(str1,i)
  onion <- read_html(url)
  
  links <- onion %>%
    html_nodes(".aoiLP") %>%
    html_nodes(".js_link") %>%
    html_attr("href") %>%
    as.character()
  
  list_of_links <- rbind(list_of_links,links)
}


