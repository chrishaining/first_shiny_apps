# global
library(shiny)
library(shinydashboard)
library(data.table)
library(DT)

data("airquality")
#monthChoices <- unique(airquality$Month)


# ui
ui <- dashboardPage(
  dashboardHeader(title="Dashboard Header",
                  #dropdownMenu(type = "messages", messageItem(from = "Chris", message = "Test message")),
                  dropdownMenuOutput(outputId = "messageMenu"),
                  dropdownMenu(type = "notifications", notificationItem(text="This is a notification")),
                  dropdownMenu(type = "tasks", taskItem(text = "This is a sample task", value=50) ),
                  dropdownMenuOutput(outputId = "taskMenu")
                  
                  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem(text = "Data", tabName = "data", icon = icon("database")),
      menuItem(text = "Plot", tabName = "plot", icon = icon("chart-bar"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "data",
              DTOutput("table1")),
      tabItem(tabName = "plot",
              plotOutput("plot1"))
    )
  )
  
)


# server
server <- function(input, output) {
  
  messageData <- data.frame(from = c("HR", "Accounting", "Ops"),
                            message = c("You're fired", "You're skint", "Your equipment is broken")
                            )
  
  output$messageMenu <- renderMenu({
    msg <- apply(messageData, 1, function(row){
      messageItem(from = row[['from']], message = row[['message']])
    })
    dropdownMenu(type = 'messages', .list = msg)
  })
  
  taskData <- data.frame(text = c("Buy milk", "Walk the dog", "Paint the fence"),
                         progress = c(50, 75, 0))
  
  output$taskMenu <- renderMenu({
    tsk <- apply(taskData, 1, function(row){
      taskItem(text = row[['text']], value = row[['progress']])
    })
    dropdownMenu(type = 'tasks', .list = tsk)
  })
  

  output$table1 <- renderDT(data.table(airquality))
  
  output$plot1 <- renderPlot({
    ggplot(data = airquality, aes(x = Day, y = Temp)) + geom_point() + geom_line()
  })
  
  
  
}


# Run the application 
shinyApp(ui = ui, server = server)
