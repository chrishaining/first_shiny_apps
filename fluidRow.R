# this file demonstrates the use of:
# fluidrows for displaying the data
# filtering the data

# global packages and variables
library(shiny)
library(DT)
library(ggplot2)
data("airquality")
monthChoices <- unique(airquality$Month)

# ui
ui <- fluidPage(

  fluidRow(
    titlePanel("AIR QUALITY DATA")
  ),
  
  fluidRow(
    verbatimTextOutput("text1")
  ),
  
  fluidRow(
    column(width=6, selectInput(inputId = "month", label = "Select a month", choices = monthChoices)),
    column(width=6,  selectInput(inputId = "column", label = "Select a column", choices=c("Wind", "Temp")))
  ),
  
  fluidRow(
    DTOutput(outputId = "datatable1")
  ),
  
  fluidRow(
    plotOutput(outputId = "plot1")
  )
)


# server
server <- function(input, output) {
  output$text1 <- renderText("Welcome to this interactive app about air quality")
  filteredData <- reactive({
    filteredData <- airquality[airquality$Month == input$month,]
    return(filteredData)
  })
  output$datatable1 <- renderDT({
    datatable(filteredData())
  })
  output$plot1 <- renderPlot({
    ggplot(data = filteredData(), aes_string(x = "Day", y = input$column)) + geom_point() + geom_line()
  })
  
}


# Run the application 
shinyApp(ui = ui, server = server)