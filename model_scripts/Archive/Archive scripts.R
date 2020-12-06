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


#shiny app and d3 mixed - overlaps
library(shiny)
library(datasets)
library(tidyr)

ui <- fluidPage(
  titlePanel("Top 20 Words"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("type", "Type of Article:",
                  choices = top_words_all$type),
      # selected = c(top_words_all$type == "Fake")),
      hr(),
      helpText("Select a type from the dropdown to display data")
    ),
    
    d3Output("d3")
  )
)

server <- function(input, output){
  output$d3 <- renderD3({
    #render d3 graph
    if(input$type == "Fake"){
      r2d3::r2d3(data=top_fake_df_words, script = "r2d3/d3_scripts.js", d3_version = "3", container = "div")
    }
    else{
      r2d3::r2d3(data=top_true_df_words, script = "r2d3/d3_scripts.js", d3_version = "3", container = "div")
    }
  })
  #output$d3.exit().remove()
  
}


shinyApp(ui,server)



#create dataset 

dataset_test <- readr::read_tsv("r2d3/data_testing.tsv")



r2d3::r2d3(data=dataset_test, script = "r2d3/d3_scripts_copy.js", d3_version = "3", container = "div")
?r2d3

all_50 <- rbind(fake_df_words, true_df_words)

all_50 %>%
  #select(word, type) %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE) %>%
  acast(word ~ sentiment, value.var = "n", fill = 0) %>%
  comparison.cloud(colors = c("tomato3", "steelblue1"),
                   max.words = 300)

layout(matrix(c(1,1,2,3), 2, 2, byrow = TRUE)) 
fake_wc
true_wc
all_wc



## shiny app Works!!!!!

#shiny using ggplot

library(shiny)
library(datasets)
library(tidyr)

ui <- fluidPage(
  titlePanel("Top 20 Words"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("type", "Type of Article:",
                  choices = top_words_all$type,
                  selected = c(top_words_all$type == "Fake")),
      hr(),
      helpText("Select a type from the dropdown to display data")
    ),
    
    mainPanel(
      plotOutput("typePlot")
    )
  )
)

server <- function(input, output){
  output$typePlot <- renderPlot({
    
    #render a plot
    top_words_all %>%
      filter(type == input$type) %>%
      ggplot(aes(word,n)) +
      geom_col() +
      ylab("Word Count") +
      coord_flip() 
  })
}

shinyApp(ui = ui, server = server)

## archive
```{r warning=FALSE,message=FALSE}
#fake
fake_output_df <- output_df %>%
  filter(DocType == "Fake") %>%
  select(-c(docId,DocType,the))


#fake
v = sort(colSums(fake_output_df),decreasing = TRUE)
myNames = names(v)
d = data.frame(word=myNames,freq=v)
wordcloud(d$word, colors=c(3,4),random.color=FALSE,d$freq,min.freq=60)

#true
true_output_df <- output_df %>%
  filter(DocType == "True") %>%
  select(-c(docId,DocType,the))

#true
v2 = sort(colSums(true_output_df),decreasing = TRUE)
myNames2 = names(v2)
d2 = data.frame(word=myNames2,freq=v2)
wordcloud(d2$word, colors=c(3,4),random.color=FALSE,d2$freq,min.freq=60)
```


#create df of true and fake words and export .tsv file to use with r2d3 script

#head(true_df)

#convert text column from factor to character 
true_df <- mutate(true_df, text = as.character(true_df$text))

#total count of words in true df
true_df_words <- true_df %>%
  unnest_tokens(word,text) %>%
  anti_join(get_stopwords()) %>%
  count(type, word, sort = TRUE)

#top 20 true words df
top_true_df_words <- true_df_words %>%
  #select(-c(type)) %>%
  filter(!Word %in% c("s","â")) %>%
  top_n(20, n)

#create .tsv file to use in r2d3 testing
con<-file(here('model_scripts','data.tsv'),encoding="UTF-8")
write.table(top_true_df_words,file=con , row.names = FALSE, sep = "\t")

#head(fake_df)

#convert text column from factor to character 
fake_df <- mutate(fake_df, text = as.character(fake_df$text))

#total count of words in fake df
fake_df_words <- fake_df %>%
  unnest_tokens(word,text) %>%
  anti_join(get_stopwords()) %>%
  count(type, word, sort = TRUE)

#top 20 fake words df
top_fake_df_words <- fake_df_words %>%
  #select(-c(type)) %>%
  filter(!word %in% c("s","â","t")) %>%
  top_n(20, n)




