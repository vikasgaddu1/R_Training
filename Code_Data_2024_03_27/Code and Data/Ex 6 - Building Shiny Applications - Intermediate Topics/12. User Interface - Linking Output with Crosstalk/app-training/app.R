# Anova Accel2R - Clinical R Training -----------------------------------
# © 2023 Anova Groups All rights reserved

# Title: Shiny UI - Linking Output with Crosstalk

# Packages & Functions on Display:
# - {crosstalk 1.2.0}: SharedData


# Concepts ----------------------------------------------------------------

# The crosstalk package allows HTML widgets like interactive tables and plots to
# talk to each other, and filter the output of one HTML element based on user
# selections in another.
#
# We will use crosstalk between plots from 'plotly' and tables from 'DT'
#
# Documentation:
# https://rstudio.github.io/crosstalk/shiny.html
# https://rstudio.github.io/crosstalk/using.html

# Setup -------------------------------------------------------------------

library(crosstalk)

library(DT)
library(dplyr)
library(shiny)
library(plotly)
library(stringr)


# User Interface ----------------------------------------------------------

ui <- fluidPage(

  titlePanel("Crosstalk Filtering"),

  sidebarLayout(
    sidebarPanel(
      sliderInput(
        "sample",
        "Random Sample Proportion:",
        min   = 0.05,
        max   = 1.00,
        value = 0.50),
    ),

    mainPanel(
      plotlyOutput("plot_1"),
      plotlyOutput("plot_2"),
      DTOutput("table_1")
    )
  )
)

# Server Operations -------------------------------------------------------

server <- function(input, output, session) {

  # Crosstalk works best when each row can be uniquely identified
  # We should not use row numbers, because rows number changes with filters
  # Keys should be safe to share publicly, as the keys will be directly visible in HTML

  df_unique <- reactive({
    iris |>
    as_tibble() |>
    rowwise() |>
    mutate(
      data_key =
        str_c(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width)) |>
      ungroup() |>
      slice_sample(prop = input$sample)
  })


  # Create Shared Data ---
  # We need to use the SharedData$new list from the crosstalk package to define
  # the data that we want to be used as the foundation for cross-communication.
  # It is best to always define a variable to use as the unique key
  # - Notice here I'm NOT using the reactive form of the dataframe

  df_shared <- SharedData$new(df_unique, key = ~data_key)


  # Create Plots ---
  # With plotly we can customize the highlight selection behaviors
  output$plot_1 <- renderPlotly({
    df_shared |>
      plot_ly(x = ~Sepal.Length, y = ~Sepal.Width, color = ~Species) |>
      add_markers() |>
      highlight(on = "plotly_selected", off = "plotly_deselect")
  })

  output$plot_2 <- renderPlotly({
    df_shared |>
      plot_ly(x = ~Petal.Length, y = ~Petal.Width, color = ~Species) |>
      add_markers() |>
      highlight(on = "plotly_selected", off = "plotly_deselect")
  })


  # Create Table ---
  # With DT, we need to set server = F in the renderDT function
  output$table_1 <- renderDT(server = F, {
    df_shared |>
      DT::datatable()
  })

}


# Run Application ---------------------------------------------------------

shinyApp(ui = ui, server = server)
