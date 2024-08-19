# Anova Accel2R - Clinical R Training -----------------------------------
# © 2023 Anova Groups All rights reserved

# Title: Shiny Performance Profiles

# Packages & Functions on Display:
# - {profvis 0.3.7}: profvis


# Concepts ----------------------------------------------------------------

# Profiling an app using `profvis` returns annotated code, showing which lines
# and operations require the most processing time to complete.
#
# In the lower panel of the profile visual we have a "flame graph" with
# milliseconds on the x-axis, and call stacks on the y-axis.
#
# If you want to read the flame graph, you read from bottom to top:
# You can see that profvis was the foundation for most of the other call stacks
# Then runApp was followed by serviceApp > flushReact > and so on
# At the top of each stack, we see the actual R function that we coded in the script
#
# - Note that the RStudio Profile menu has a tendency to not work with Shiny apps
#
#
# General Guidelines for Shiny Performance:
# - Pre-process as much data as possible
# - Try to avoid applying dynamic filters to grouped data
# - Reading CSV files tends to be faster than RDS files
# - Test using a cache to speed up UI results with bindCache
# - Be aware of where you're reading in data, see 'scoping' link for more
# - Consider asynchronous processing in specific use cases, see 'async' link for more
#

# Documentation:
# https://rstudio.github.io/profvis/index.html
# https://shiny.rstudio.com/articles/async.html
# https://shiny.rstudio.com/articles/scoping.html


# Platform Specific Documentation
# [ShinyApps.io]                - https://shiny.rstudio.com/articles/scaling-and-tuning.html
# [Shiny Server Pro] &          - https://shiny.rstudio.com/articles/scaling-and-tuning-ssp-rsc.html
#              [Posit Connect]


# Setup -------------------------------------------------------------------

library(shiny)
library(profvis)

library(dplyr)
library(readr)
library(ggplot2)

data_path <- "../../_data"

# Build Profile -----------------------------------------------------------

run_profile <- "no"

if (run_profile == "yes") {
    profvis::profvis({
        app_path <- rstudioapi::getSourceEditorContext()$path
        shiny::runApp(app_path)
    })
}


# Pre-Processing ----------------------------------------------------------



# User Interface ----------------------------------------------------------

ui <- fluidPage(

    titlePanel("Shiny Performance Profiles"),

    sidebarLayout(
        sidebarPanel(
            actionButton("read_csv",  "Read CSV"),
            actionButton("read_rds",  "Read RDS"),
            hr(),
            selectInput("group_var",  "Group by:",      choices = c("cut", "color")),
            numericInput("min_price", "Minimum Price:", value = 300, min = 300, max = 20000, step = 100),
            numericInput("min_carat", "Minimum Carat:", value = 0,   min = 0,   max = 6,     step = 0.1)),

        mainPanel(
            tableOutput("data_summary"),
            plotOutput("diamond_plot")
        )
    )
)

# Server Operations -------------------------------------------------------

server <- function(input, output) {

    data_csv <-
        eventReactive(input$read_csv, {
            paste0(data_path, "/diamonds.csv") |>
                read_csv(show_col_types = F)
        })

    data_rds <-
        eventReactive(input$read_rds, {
            paste0(data_path, "/diamonds.rds") |> read_rds()
        })


    grouped_data <- reactive({
        # Not using `data_rds`/`data_csv`,
        # because conditional structure is outside scope of this lesson

        diamonds |>
            group_by(across(input$group_var)) |>
            filter(
                price >= input$min_price,
                carat >= input$min_carat)
    })

    output$data_summary <- renderTable({
        Sys.sleep(2)
        grouped_data() |>
            summarize(
                row_count = n(),
                carat_min = min(carat),
                carat_max = max(carat),
                price_min = min(price),
                price_max = max(price))
    })

    output$diamond_plot <- renderPlot({
        Sys.sleep(2)
        grouped_data() |>
            ggplot(aes(x = carat, y = price)) +
            geom_point() +
            labs(title = "Scatterplot of Diamonds")
    })
}


# Run Application ---------------------------------------------------------

shinyApp(ui = ui, server = server)
