#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(dashboardthemes)

ui <- dashboardPage(
    dashboardHeader(),
    dashboardSidebar(),
    dashboardBody(### changing theme
        shinyDashboardThemes(
            theme = "blue_gradient"
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {}

# Run the application 
shinyApp(ui = ui, server = server)
