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

library(shiny)
library(plotly)
library(crosstalk)
library(tidyverse)


# User Interface ----------------------------------------------------------

ui <- fluidPage(

    titlePanel("Linking Output with Crosstalk"),

    sidebarLayout(
        sidebarPanel(
            varSelectInput(
                inputId = "variable",
                label   = "Select a Variable:",
                data    = diamonds
            )
        ),

        mainPanel(
            plotlyOutput("distribution_plot"),
            plotlyOutput("scatter_plot")
        )
    )
)


# Server Operations -------------------------------------------------------

server <- function(input, output) {

    # Crosstalk Definitions
    data_uniquekey <- diamonds |> sample_n(1000) |> rowid_to_column()
    data_filtered  <- SharedData$new(data_uniquekey, key = ~rowid)

    # Reactive Definitions
    variable      <- reactive(input$variable)

    # Distribution Plot
    # Notice we use base::get() to pass dynamic variables into plotly
    output$distribution_plot <- renderPlotly({
            data_filtered |>
                plot_ly(x = ~ get(variable())) |>
                add_histogram() |>
                layout(
                    xaxis = list(title = variable()),
                    barmode = "overlay") |>
                highlight(on = "plotly_selected", off = "plotly_deselect")
    })

    # Filtered Scatter Plot
    output$scatter_plot <- renderPlotly({
        data_filtered |>
            plot_ly(x = ~carat, y = ~price) |>
            add_markers() |>
            layout(title = str_glue("Scatterplot of {variable()} filtered with crosstalk")) |>
            highlight(on = "plotly_selected", off = "plotly_deselect")
    })
}

# Run Application ---------------------------------------------------------

shinyApp(ui = ui, server = server)
