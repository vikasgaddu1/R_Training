#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#   http://shiny.rstudio.com/
#

library(shiny)
library(reactlog)

# Setup ----
# Temperature Conversion Functions
fn_temp_to_c <- function(value){(value - 32) * 5 / 9}
fn_temp_to_f <- function(value){(value * 9 / 5) + 32}

fn_temp_conversion <- function(value, to){
  if (to == "F to C"){
    fn_temp_to_c(value)
  } else if (to == "C to F"){
    fn_temp_to_f(value)
  }
}

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
          numericInput(
            inputId = "baseline_temp",
            label   = "Enter a Baseline Temperature",
            value   = 98.7,
            step    = 0.01,
            min     = -200,
            max     =  200),

          radioButtons(
            inputId = "temp_conversion",
            label   = "Conversion Type",
            choices = c("F to C", "C to F")
          )),

        # Show a plot of the generated distribution
        mainPanel(
          textOutput("converted_temp"),
          hr(),
          verbatimTextOutput("debug")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

  converted_temp <- reactive({
  # browser()
    fn_temp_conversion(input$baseline_temp, input$temp_conversion)
  })

  browser()

  output$converted_temp <- renderText({
    paste(input$baseline_temp,
          "converted from",
          input$temp_conversion,
          "is",
          round(converted_temp(), digits = 3),
          "degrees.")
  })
}

# Run the application
shinyApp(ui = ui, server = server)
