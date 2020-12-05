draw_top_words_chart <- function(){
  ui <- fluidPage(
    titlePanel(tags$strong("Top 20 Words")),
    
    verticalLayout(
      tags$h3("Fake News Words"),
      d3Output("fake"),
      tags$h3("True News Words"),
      d3Output("real")
    )
    
  )
  
  server <- function(input, output){
    output$fake <- renderD3(r2d3::r2d3(data=top_fake_df_words, script = "d3_scripts.js", d3_version = "3", container = "div"))
    output$real <- renderD3(r2d3::r2d3(data=top_true_df_words, script = "d3_scripts.js", d3_version = "3", container = "div"))
    
  }
  
  
  shinyApp(ui,server)
}



