library(shiny)
source('explore_19-covid.R')

ui <- fluidPage(
  selectInput("date", label = h3("Choose Date"), 
              choices = covid19_collective$Date, 
              selected = 1),
  plotOutput('map_by_date_plot')
  
)

server <- function(input, output){
  output$map_by_date_plot <- renderPlot(map_by_date(input$date))
}

shinyApp(ui = ui, server = server)
