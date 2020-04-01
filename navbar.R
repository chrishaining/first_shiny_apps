# this file demonstrates the use of:
# sidebars for displaying the data
# filtering the data

# global packages and variables
library(shiny)
library(DT)
library(ggplot2)
data("airquality")
monthChoices <- unique(airquality$Month)

# ui
ui <- navbarPage("Navbar",
  tabPanel("Inputs",
           selectInput(inputId = "month", label = "Select a month", choices = monthChoices),
           selectInput(inputId = "column", label = "Select a column", choices=c("Wind", "Temp")),
           checkboxInput("showTitle", label = "Check to enter the title", value = FALSE),
           conditionalPanel(condition = "input.showTitle == true", 
                            textInput("title", label = "Enter a plot title", placeholder = "Title"))
  ),
  navbarMenu("Outputs", 
             tabPanel("Table", DTOutput(outputId = "datatable1")),
             tabPanel("Plot", plotOutput(outputId = "plot1"))
  )
  
)

#ui <- fluidPage(
 
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
    
    if (input$showTitle == TRUE){
      ggplot(data = filteredData(), aes_string(x = "Day", y = input$column)) + geom_point() + geom_line() + ggtitle(input$title)
    }
    
    else {
      ggplot(data = filteredData(), aes_string(x = "Day", y = input$column)) + geom_point() + geom_line()
    }
  })
  
}


# Run the application 
shinyApp(ui = ui, server = server)