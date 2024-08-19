#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#   http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

ui <- fluidPage(
  titlePanel("Caching Results"),
  sidebarLayout(
    sidebarPanel(
      varSelectInput(
        inputId  = "select",
        label    = "Select Variables",
        multiple = T,
        selected = colnames(diamonds),
        data     = diamonds),
      actionButton(
        inputId  = "button",
        label    = "Render Plot"),
      actionButton(
        inputId  = "reset",
        label    = "Reset")),
    mainPanel(
      plotOutput("out_plot")
    ))
)

server <- function(input, output) {
  my_vars <- reactive({
    as.character(input$select)
  })
  observeEvent(input$reset, {
    output$out_plot <- NULL
  })
  observeEvent(input$button,{
    output$out_plot <- renderPlot({
      diamonds[my_vars()] |> plot()
    })
  })
}
# Run the application
shinyApp(ui = ui, server = server)
