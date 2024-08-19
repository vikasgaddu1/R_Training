# Anova Accel2R - Clinical R Training -----------------------------------
# © 2023 Anova Groups All rights reserved

# Title: Shiny - Bookmarking App State

# Packages & Functions on Display:
# - {shiny 1.7.3}: enableBookmarking, bookmarkButton


# Concepts ----------------------------------------------------------------

# There are two types of save states: Encoded states simply store the input
# values in the URL of the app Server states retrieve the stored values and
# output from the server
#
# - Encoded states can become very long, and are best used for simple cases
# - Server states require a host that supports bookmarking
# - Server states can save extra files to the server
# - Server states will require backend setup to manage the states saved to disk
#
# ---
#
# How to enable bookmarking:
# - Add enableBookmarking() to the script
# - Add a bookmarkButton() to the UI
# - To enable bookmarking, the UI portion of the app needs to be defined as a
#  function with the 'request' argument
#
# ---
#
# How to use bookmarking:
# - For both encoded and server save states, you simply save the given URL
#  and paste it into the browser when you want to restore that particular state
#


# Documentation
# https://shiny.rstudio.com/articles/bookmarking-state.html
# https://shiny.rstudio.com/articles/advanced-bookmarking.html

# Setup -------------------------------------------------------------------

library(shiny)
library(tidyverse)

enableBookmarking("url")

# User Interface ----------------------------------------------------------

ui <- fluidPage(
    titlePanel("Shiny Bookmarking Example"),
    sidebarLayout(
        sidebarPanel(
            varSelectInput(
                inputId = "var_x",
                label   = "Select X Variable:",
                data    = diamonds),
            varSelectInput(
                inputId = "var_y",
                label   = "Select Y Variable:",
                data    = diamonds),
            varSelectInput(
                inputId = "var_color",
                label   = "Select Color Variable:",
                data    = diamonds),
            sliderInput(
                inputId = "plot_sample",
                label   = "Sample Size:",
                min     = 250,
                max     = 5000,
                value   = 500,
                step    = 250),
            sliderInput(
                inputId = "plot_size",
                label   = "Scatter Point Size:",
                min     = 1,
                max     = 10,
                value   = 3,
                step    = 1),
            sliderInput(
                inputId = "plot_alpha",
                label   = "Scatter Point Opacity:",
                min     = 0.10,
                max     = 1,
                value   = 0.50,
                step    = 0.10),
            textInput(
                inputId = "plot_title",
                label   = "Enter Plot Title:",
                value   = "A Dynamic Scatterplot"),

            hr(),
            bookmarkButton()
            ),
        mainPanel(
            plotOutput("plot")
        )
    )
)


# Server Operations -------------------------------------------------------

server <- function(input, output, session) {
    output$plot <- renderPlot({
        diamonds |>
            slice_sample(n = input$plot_sample) |>
            ggplot(aes(
                x     = .data[[input$var_x]],
                y     = .data[[input$var_y]],
                color = .data[[input$var_color]])) +
            geom_point(
                size = input$plot_size,
                alpha = input$plot_alpha) +
            labs(title = input$plot_title,
                 subtitle = paste(input$var_x, "by", input$var_y))
    })
}

# Run Application ---------------------------------------------------------

shinyApp(ui = ui, server = server)

