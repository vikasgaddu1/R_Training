
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2023 Anova Groups All rights reserved

# Title: Shiny UI - Dashboard Layouts

# Packages & Functions on Display:
# - {shiny          1.7.3}: fluidRow
# - {shinydashboard 0.7.2}: dashboardPage, dashboardSidebar, dashboardBody, box


# Concepts ----------------------------------------------------------------

# Using `shinydashboard` to create dashboard style layouts


# Online Documentation
# https://rstudio.github.io/shinydashboard/get_started.html
# https://rstudio.github.io/shinydashboard/structure.html


# Setup -------------------------------------------------------------------

library(shiny)
library(dplyr)
library(ggplot2)
library(shinydashboard)

# User Interface ----------------------------------------------------------

ui <- dashboardPage(

    dashboardHeader(title = "Shiny Dashboards"),

    dashboardSidebar(

        varSelectInput(
            inputId  = "var_select",
            label    = "Select a variable",
            data     = diamonds,
            multiple = F),

        sliderInput(
            inputId = "var_filter",
            label   = "Filter range",
            value   = range(diamonds$carat),
            min     = min(diamonds$carat),
            max     = max(diamonds$carat),
            step    = 0.10,
            ticks   = F),

        hr(),

        actionButton(
            inputId = "button",
            label   = "Submit Operation")
    ),

    dashboardBody(
        fluidRow(
            box(
                width = 12,
                title = "Diamonds Plot",
                plotOutput("plot")
            )
        ),
        fluidRow(
            box(width = 6,
                title = "Variable Summary",
                verbatimTextOutput("summary")),
            box(width = 6,
                title = "Data Description",
                textOutput("description"))
        )
    )
)

# Server Operations -------------------------------------------------------

server <- function(input, output) {

    # Filter Data
    my_data <- eventReactive(input$button, {
        diamonds |>
            filter(
                carat <= max(input$var_filter),
                carat >= min(input$var_filter))
    })

    # # Plot Data
    my_plot <- eventReactive(input$button, {
        if (my_data()[[input$var_select]] |> is.factor()){
            my_data()[[input$var_select]] |> plot(main = paste("Plot of", input$var_select))
        } else {
            my_data()[[input$var_select]] |> hist(main = paste("Plot of", input$var_select))
        }
    })

    output$plot <- renderPlot(my_plot())

    # # Summary of Data
    my_summary <- eventReactive(input$button, {
        my_data()[[input$var_select]] |> summary()
    })

    output$summary <- renderPrint(my_summary())

    # Description of data
    my_description <- eventReactive(input$button, {
        paste("The diamonds data set has",
              nrow(diamonds),
              "rows originally, but is filtered to have",
              nrow(my_data()),
              "rows.  The currently selected column is",
              input$var_select,
              "which is a variable of type",
              diamonds[[input$var_select]] |> class() |> paste(collapse = " & "))
    })

    output$description <- renderText(my_description())

}


# Run Application ---------------------------------------------------------

shinyApp(ui = ui, server = server)
