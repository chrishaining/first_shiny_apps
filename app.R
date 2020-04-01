# global 
library(tidyr)
library(shiny)
library(ggplot2)
library(DT)
 

data("economics")
colChoices <- colnames(economics)
pceChoices <- unique(economics$pce)

# Define UI for application 
ui <- fluidPage(

    # Application title
    titlePanel("Economic Data"),
    verbatimTextOutput("text1"),
    selectInput(inputId = "columnSelector", label="Select a column", choices = colChoices),
    selectInput(inputId = "pceSelector", label="Select pce", choices = pceChoices),
    plotOutput("plot1"),
    tableOutput("table1")
    
)

# Define server logic 
server <- function(input, output) {
    output$text1 <- renderText("Welcome to this economics plot.")

    output$table1 <- renderTable(economics)
    
    filterData <- reactive({
        filteredData <- economics[economics$pce == input$pceSelector]
        return(filteredData)
    })
    
    output$plot1 <- renderPlot({
        ggplot(data=filterData(), aes_string(x="date", y=input$columnSelector)) + geom_line()
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
