# this file demonstrates the use of:
# sidebars for displaying the data
# filtering the data based on x or y axis

# global packages and variables
library(shiny)
library(DT)
library(ggplot2)
data("airquality")
xAxisChoices <- colnames(airquality)
yAxisChoices <- colnames(airquality)
tempChoices <- unique(airquality$Temp)

# ui
ui <- fluidPage(
  titlePanel("AIR QUALITY DATA"),
  verbatimTextOutput("text1"),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "xSelector", label = "Select the X axis", choices = xAxisChoices),
      selectInput(inputId = "ySelector", label = "Select the Y axis", choices = yAxisChoices),
      selectInput(inputId = "tempSelector", label = "Select the temperature", choices = tempChoices),
      #checkboxInput("showTitle", label = "Check to enter the title", value = FALSE),
      #conditionalPanel(condition = "input.showTitle == true", 
       #                textInput("title", label = "Enter a plot title", placeholder = "Title")),
      actionButton("refreshPlot", label="Refresh")
    ),
    mainPanel(
     plotOutput("plot1")
    )
  )
)


# server
server <- function(input, output) {
  output$text1 <- renderText("Welcome to this interactive app about air quality")
  filteredData <- reactive({
    filteredData <- airquality[airquality$Temp == input$tempSelector,]
    return(filteredData)
  })
  
  
  plot1 <- eventReactive(input$refreshPlot,{
    ggplot(data = filteredData(), aes_string(x = input$xSelector, y = input$ySelector)) + geom_point() 
    })
  
   # if (input$showTitle == TRUE){
    #  ggplot(data = filteredData(), aes_string(x = input$xSelector, y = input$ySelector)) + geom_point() + ggtitle(input$title)
    #}
    
    #else {
     # ggplot(data = filteredData(), aes_string(x = input$xSelector, y = input$ySelector)) + geom_point()
  #  }
  #})
  
  output$plot1 <- renderPlot(plot1())
  
}


# Run the application 
shinyApp(ui = ui, server = server)