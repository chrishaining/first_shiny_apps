# global 
library(tidyr)
library(shiny)
library(ggplot2)
library(DT)




# Define UI for application 
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      fileInput("file1", "Upload a csv file",
                multiple = FALSE,
                accept = c(".csv")),
      textInput("separator", "Enter the separator character", value = ","),
      checkboxInput("header", label = "File contains a header?", value = TRUE)
    ),
    mainPanel(
      DTOutput("data1")
    )
  )

)

# Define server logic 
server <- function(input, output) {
  
  output$data1 <- renderDT({
    
    req(input$file1)
    
    df <- read.csv(input$file1$datapath, header = input$header, sep = input$separator)
  
    return(datatable(df))
    })

}

# Run the application 
shinyApp(ui = ui, server = server)
