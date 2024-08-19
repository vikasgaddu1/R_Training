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
# shiny::runApp("C:/Users/User/OneDrive - ManpowerGroup/Stage 4/Content/Course Development/Building Shiny Applications/4. Debug - For the R User/app-training/app.R", display.mode = "showcase")

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

library(shiny)
library(reactlog)

# User Interface ----------------------------------------------------------

ui <- fluidPage(

  titlePanel("Old Faithful Geyser Data"),

  sidebarLayout(
    sidebarPanel(
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30),
    ),

    mainPanel(
      plotOutput("distPlot"),

      # verbatimTextOutput("debug_output")

    )
  )
)

# Server Operations -------------------------------------------------------

server <- function(input, output) {

  output$distPlot <- renderPlot({
    x    <- faithful[, 2]

#  browser()

    bins <- seq(min(x), max(x), length.out = input$bins + 1)

    # The stderr() is not a statistical standard error function
    # Rather, it ensures the message is delivered to the console

    # cat(
    #  file = stderr(),
    #  "We are using", input$bins, "to draw the histogram\n")

    hist(x, breaks = bins, col = 'darkgray', border = 'white',
         xlab = 'Waiting time to next eruption (in mins)',
         main = 'Histogram of waiting times')

  })

  output$debug_output <- renderPrint({

    list(
      chosen_bins = input$bins,
      # other arguments to capture
    )

  })

}


# Run Application ---------------------------------------------------------

shinyApp(ui = ui, server = server)
