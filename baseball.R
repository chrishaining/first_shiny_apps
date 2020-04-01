#Global file - equivalent of global.R - for importing packages and files, and creating global variables
library(shiny)
library(DT)
library(dplyr)
library(ggplot2)
library(readr)
library(shinydashboard)
library(shinyWidgets)

baseball_data <- as.data.frame(read_csv('baseball.csv'))
playerChoices <- unique(baseball_data$name)
statChoices <- c("G","AB","R","H","Doubles","Triples","HR","RBI","BB","SO")
teamChoices <- unique(baseball_data$franchName)
yearChoices <- unique(baseball_data$yearID)



# Define UI for application 
ui <- dashboardPage(
  skin="green",
  dashboardHeader(title="Baseball Statistics 1972-2015"),
  
  dashboardSidebar(
    setBackgroundColor(
      color = "#fcba03",
      shinydashboard = TRUE
    ),
    width=300,
    sidebarMenu(
      menuItem(text = "Player Data",
               startExpanded = TRUE,
               menuSubItem(text = "Data", tabName = "playerData"),
               menuSubItem(text = "Plots", tabName = "playerPlot")
               ),
      
      menuItem(text = "Data per Team/Year", tabName = "dataPerTeamYear"),
      menuItem(text = "Yearly leaders", tabName = "yearlyLeaders"),
      selectInput(inputId = "playerSelect", label = "Select a player", choices = playerChoices, selected = "Kevin Gross"),
      selectInput(inputId = "statSelect", label = "Select a stat", choices = statChoices, selected = "HR"),
      selectInput(inputId = "teamSelect", label = "Select a team", choices = teamChoices, selected = "Arizona Diamondbacks"),
      selectInput(inputId = "yearSelect", label = "Select a year", choices = yearChoices, selected = 1976)
      )
      
    ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "playerData",
              DTOutput("table1")),
      tabItem(tabName = "playerPlot",
              plotOutput("plot1"))
    )
    
  )

  
)

# Define server logic 
server <- function(input, output) {
  
  #output$table1 <- renderDT({datatable(baseball_data)})
  output$table1 <- renderDT(baseball_data)
  
  output$plot1 <- renderPlot({
    ggplot(data = baseball_data, aes(x=name, y = G)) + geom_line()
    
  })
}

# Run the application 
shinyApp(ui = ui, server = server)