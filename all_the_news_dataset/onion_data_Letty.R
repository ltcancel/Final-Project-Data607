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


onion %>%
  html_nodes(".js_link") %>%
  html_attr("href") %>%
  as.character()
