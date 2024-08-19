
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
library(shinydashboard)


# User Interface ----------------------------------------------------------

ui <- dashboardPage(

    # Application title
    dashboardHeader(title = "Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins
    dashboardSidebar(
        sliderInput(
            inputId = "bins",
            label   = "Number of bins:",
            min     = 1,
            max     = 50,
            value   = 30)
    ),

    # Show a plot of the generated distribution
    dashboardBody(

        # First Row
        fluidRow(
            box(plotOutput("distPlot", height = 250),
                title  = "Box 1: A sample histogram",
                footer = "Note: Width is 8 of 12 units (i.e. 2/3 of available space)",
                width  = 8),
            box(title  = "Just a placeholder",
                footer = "Note: Width is 4 of 12 units (i.e. 1/3 of available space",
                width  = 4)),

        # Second Row
        fluidRow(
            box(title = "Row 2, Column 1", width = 6),
            box(title = "Row 2, Column 2", width = 6))

    ) # Close dashboardBody

) # Close dashboardPage


# Server Operations -------------------------------------------------------

server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white',
             xlab = 'Waiting time to next eruption (in mins)',
             main = 'Histogram of waiting times')
    })
}


# Run Application ---------------------------------------------------------

shinyApp(ui = ui, server = server)
