# Anova Accel2R - Clinical R Training -----------------------------------
# © 2023 Anova Groups All rights reserved

# Title: Shiny Debugging for the R User

# Packages & Functions on Display:
# - {base  4.2.3}: browser, cat(file = stderr())
# - {shiny 1.7.3}: runnApp(display.mode = "showcase"), options(shiny.reactlog = T)


# Concepts ----------------------------------------------------------------

# We'll cover pausing execution to inspect Shiny operations, tracing information
# throughout the operation so that we don't have to pause it, and then finding
# the source of errors and finding their cause

# ---

# RStudio Debug Menu
# Breakpoints do not work in Shiny scripts, but we can use the `browser()`
# to step through code.  This works in either the server or the ui sections

# ---

# Shiny Showcase Mode
# We can use 'showcase mode' to visualize which portions of code are running as
# a user is interacting with the code. Showcase Mode works best when running in
# external window

# rstudioapi::getActiveDocumentContext()$path |>
#  shiny::runApp(display.mode = "showcase")

# ---

# Reactive Interaction Log
# Using the 'reactive log' helps us visualize the reactive interactions. We
# include this option in the application script, then we hit CTRL+F3 once the
# application is running. This gives us a summary of the runtimes between elements.
# If this seems valuable to you, read more: https://rstudio.github.io/reactlog/

# options(shiny.reactlog = T)

# ---

# Using print statements we can use `cat(file = stderr())` to print messages to
# the console, describing exactly what is happening in the Shiny process


# Online Documentation
# https://shiny.rstudio.com/articles/debugging.html



# Setup -------------------------------------------------------------------

options(shiny.reactlog = T)

library(shiny)
library(reactlog)

df_bmi <- readRDS("../../_data/bmi.rds")


# Temperature Conversion
fn_temp_to_c <- function(value){(value - 32) * 5 / 9}
fn_temp_to_f <- function(value){(value * 9 / 5) + 32}

fn_temp_conversion <- function(value, to){
    if (to == "F to C"){
        fn_temp_to_c(value)
    } else if (to == "C to F"){
        fn_temp_to_f(value)
    }
}


# User Interface ----------------------------------------------------------

ui <- fluidPage(

    titlePanel("Old Faithful Geyser Data"),

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
            )
        ),


        mainPanel(
            textOutput("converted_temp"),
            hr(),
            verbatimTextOutput("debug")
        )
    )
)

# Server Operations -------------------------------------------------------

server <- function(input, output) {

    converted_temp <- reactive({
        browser()
        fn_temp_conversion(input$baseline_temp, input$temp_conversion)
    })


    output$converted_temp <- renderText({

        Sys.sleep(0.50)

        cat("\nRaw Result:",
            converted_temp(),
            file = stderr())

        paste(input$baseline_temp,
              "converted from",
              input$temp_conversion,
              "is",
              round(converted_temp(), digits = 3),
              "degrees.")
    })

    output$debug <- renderPrint({
        list(
            in_temp = input$baseline_temp,
            in_conv = input$temp_conversion,
            temp_cv = converted_temp(),
            misc    = 1 + 2 * 3 / 4 ^ 5
        )
    })

}


# Run Application ---------------------------------------------------------

shinyApp(ui = ui, server = server)
