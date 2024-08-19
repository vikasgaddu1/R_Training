# Anova Accel2R - Clinical R Training -----------------------------------
# © 2023 Anova Groups All rights reserved

# Title: Introduction to Course

# Setup -------------------------------------------------------------------

library(shiny)
library(dplyr)
library(ggplot2)

df_bmi <- readRDS("../../_data/bmi.rds")

# User Interface ----------------------------------------------------------

ui <- fluidPage(

    titlePanel("Introduction to Course"),

    sidebarLayout(
        sidebarPanel(
            sliderInput("select_sample",
                        "Select a sample proportion:",
                        min   = 0.10,
                        max   = 1.00,
                        step  = 0.05,
                        value = 0.25)
        ),

        mainPanel(
            plotOutput("plot_bmi")
        )
    )
)

# Server Operations -------------------------------------------------------

server <- function(input, output) {

    output$plot_bmi <- renderPlot({
        df_bmi |>
            slice_sample(prop = input$select_sample) |>
            ggplot(aes(x = WEIGHT, y = HEIGHT)) +
            geom_point()
    })
}


# Run Application ---------------------------------------------------------

shinyApp(ui = ui, server = server)
