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

# Build Profile -----------------------------------------------------------

run_profile <- "no"

if (run_profile == "yes") {
  profvis({
    app_path <- rstudioapi::getSourceEditorContext()$path
    runApp(app_path)
  })
}


# User Interface ----------------------------------------------------------

ui <- fluidPage(

  titlePanel("Profiling an Application"),

  sidebarLayout(
    sidebarPanel(
      sliderInput(
        "bins",
        "Number of bins:",
        min   = 1,
        max   = 50,
        value = 30),

      radioButtons(
        inline  = T,
        inputId = "color",
        label   = "Select a color:",
        choices = c("Gray"    = "darkgray",
                    "Blue"    = "lightblue",
                    "Orange"  = "orange")),

      hr(),

      actionButton(
        "button",
        "Run Process")
    ),

    mainPanel(
      textOutput("message"),
      hr(),
      plotOutput("distPlot")
    )
  )
)

# Server Operations -------------------------------------------------------

server <- function(input, output, session) {

  # Prepare Data ---
  df <- faithful$waiting

  # Process Input ---
  my_bin <- reactive({input$bins})
  my_col <- reactive({input$color})

  # Prepare Output ---
  output$message <- renderText({

    Sys.sleep(0.50)

    paste("You chose the color", my_col(),
          "with", my_bin(), "bins.")
  })

  output$distPlot <- renderPlot({

    Sys.sleep(1)

    hist(df,
         breaks = seq(min(df), max(df), length.out = my_bin() + 1),
         col = my_col(), border = 'white',
         xlab = 'Waiting time to next eruption (in mins)',
         main = 'Histogram of waiting times')
  })

  # Action Button ---
  observeEvent(input$button, {
    cat("Running the process...\n")
    Sys.sleep(2)
    cat("The process is complete.\n")
  })
}


# Run Application ---------------------------------------------------------

shinyApp(ui = ui, server = server)


