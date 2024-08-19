# Anova Accel2R - Clinical R Training -----------------------------------
# © 2023 Anova Groups All rights reserved

# Title: Shiny Reactions - Controlling Updates

# Packages & Functions on Display:
# - {shiny 1.7.3}: isolate, eventReactive


# Concepts ----------------------------------------------------------------

# Isolate works in a way that is similar to eventReactive, but allows for some
# flexibility in how to code it.  Using isolate is beneficial when you are using
# the reactive values only once, and don't necessarily need to turn each UI
# dependent value into a reactive value

# In general, you may not need to use isolate() on its own, because its works in
# a similar way as eventReactive and observeEvent. However, it is good to know
# how this works for those cases that you may need finer control

# Online Documentation
# https://shiny.rstudio.com/articles/isolation.html
# https://mastering-shiny.org/reactive-motivation.html
# https://shiny.rstudio.com/articles/execution-scheduling.html
# https://shiny.rstudio.com/articles/understanding-reactivity.html


# Setup -------------------------------------------------------------------

library(shiny)
library(dplyr)
library(ggplot2)

df_bmi <- readRDS("../../_data/bmi.rds")


# User Interface ----------------------------------------------------------

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

# Server Operations -------------------------------------------------------

server <- function(input, output) {

    ## Using Isolate ----

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


# Run Application ---------------------------------------------------------

shinyApp(ui = ui, server = server)
