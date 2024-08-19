#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#   http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(ggplot2)

df_bmi <- readRDS("../../_data/bmi.rds")

# Define UI for application that draws a histogram
ui <- fluidPage(

  titlePanel("Reactives - Control Updates"),

  sidebarLayout(
    sidebarPanel(

      h4("Using Isolate"),
      selectInput(
        inputId = "plot_x",
        label   = "X-Axis Variable",
        choices = df_bmi |> select(where(is.numeric)) |> colnames()),

      selectInput(
        inputId = "plot_y",
        label   = "Y-Axis Variable",
        choices = df_bmi |> select(where(is.numeric)) |> colnames()),

      sliderInput(
        inputId = "plot_p",
        label   = "Proportion of Data to Sample",
        min     = 0,
        max     = 1,
        step    = 0.05,
        value   = 0.60),

      hr(),

      actionButton(
        inputId = "btn_isolate",
        label = "Generate Plot"),

      hr(),
      h4("Using Event Reactive"),

      actionButton(
        inputId = "btn_sample",
        label   = "1. Sample Data"),

      actionButton(
        inputId = "btn_ggplot",
        label   = "2. Generate ggplot")

    ),

    mainPanel(
      h4("Using Isolate"),
      plotOutput("plot_1"),
      hr(),
      h4("Using Event Reactive"),
      textOutput("message"),
      plotOutput("plot_2")
    )
  )

)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$plot_1 <- renderPlot({

      if (input$btn_isolate == 0){
        return()
      } else {

        isolate({
          data_x <- input$plot_x
          data_y <- input$plot_y
          data_p <- input$plot_p
        })

        df_bmi |>
          slice_sample(prop = data_p) |>
          select(all_of(c(data_x, data_y))) |>
          plot()
      }

      })

    ## Using Event Reactive ----

    # Take random sample
    rdf_bmi <- eventReactive(input$btn_sample, {
      df_bmi |> slice_sample(prop = input$plot_p)
    })


    # Generate Message
    message <- eventReactive(input$btn_sample, {
      paste("The random sample of data has",
            nrow(rdf_bmi()),
            "rows, and we will generate a plot using",
            input$plot_x,
            "on the x axis and",
            input$plot_y,
            "on the y axis.")
    })

    output$message <- renderText(message())

    # Create ggplot
    plot_2 <- eventReactive(input$btn_ggplot, {
      rdf_bmi() |>
        ggplot(aes(x = .data[[input$plot_x]],
                   y = .data[[input$plot_y]])) +
        geom_point()
    })

    output$plot_2 <- renderPlot(plot_2())



}

# Run the application
shinyApp(ui = ui, server = server)
