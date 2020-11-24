#libraries 
library(rvest)

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

pg1 <- read_html(url1)

#article title
pg1 %>%
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
https://www.theonion.com/latest?startTime=1606136700715
https://www.theonion.com/latest?startTime=1605816000526
https://www.theonion.com/latest?startTime=1605705780724
https://www.theonion.com/latest?startTime=1605539700275
https://www.theonion.com/latest?startTime=1605204000944
