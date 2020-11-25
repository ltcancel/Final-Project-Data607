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
iterate_onion_url<-function(base_url, max){
  link_list<-list()
  for(i in 0:max){
    pagenum<-20*i
    temp<-paste0(base_url,as.character(pagenum))
    link_list<-c(link_list,temp)
  }
  return(link_list)
}

#pull all onion articles from a single page
onion_links<-function(onion_links_list){
  onion_links_list<-onion_links_list
  onionURL<-list()
  for (i in 1:length(onion_links_list)){
    html<-read_html(unlist(onion_links_list[i]))
    temp_urls<-html %>%
      html_nodes(".aoiLP") %>%
      html_nodes(".js_link") %>%
      html_attr("href") %>%
      as.character()
    onionURL<-append(onionURL,temp_urls)
  }
  return(onionURL)
}

#pull all links from all 6 pages of URLs
all_links<-function(base_url,max){
  
  base_url<-base_url
  max<-max
  link_list<-iterate_onion_url(base_url,max)
  onion_link_list<-list()
  for (i in 1:length(link_list)){
    temp_list<-onion_links(link_list[i])
    
    onion_link_list<-append(onion_link_list,temp_list)
  }
  onion_link_list<-onion_link_list%>%
    unlist()
  return(onion_link_list)
}

#function for pulling single onion article
onion_scrape<-function(link_to_onion_page){
  
  #turn list element into a character
  char_link<-as.character(link_to_onion_page)
  #read html into R
  url<-read_html(char_link)
  
  #article title
  articleTitle <- url %>%
    html_nodes(".bBLibw") %>%
    html_text()
  
  #article publish date and time
  publishDate <- url %>%
    html_nodes(".gWMcOL") %>%
    html_attr("datetime") %>%
    as.character()
  
  #article text
  articleText <- url %>%
    html_nodes(".js_post-content") %>%
    html_text()
  
  
  onion_vector<-c(articleTitle,publishDate,articleText,char_link)
  
  return(onion_vector)
  
}

#function for applying onion scrape to all articles in a list and building a data.frame
all_onion_scrape<-function(onion_link_list){
  urls<-onion_link_list
  #create data frame to load info into
  df_onion<-data.frame("articleTitle"=character(),"publishDate"=character(),"articleText"=character(),"href"=character())
  for(i in 1:length(urls)){
    #fill temporary vector with onion article info
    temp_onion<-onion_scrape(urls[i])
    #append row to output data frame
    df_onion<-rbind(df_onion,temp_onion)
  }
  #return data frame with onion articles in it
  colnames(df_onion)<-c("article_title","publish_date","article_text","link")
  return(df_onion)
}

#final function
final_onion_scrape<-function(base_url,max){
  base_url<-base_url
  max<-max
  onion_link_list<-all_links(base_url=base_url,max=max)
  final_output_df<-all_onion_scrape(onion_link_list)
  return(final_output_df)
}

#test scrape
data <- final_onion_scrape(base_url = base_url, max=6)

