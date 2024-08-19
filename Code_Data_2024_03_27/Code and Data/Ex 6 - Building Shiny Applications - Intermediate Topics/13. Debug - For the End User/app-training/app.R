# Anova Accel2R - Clinical R Training -----------------------------------
# © 2023 Anova Groups All rights reserved

# Title: Debugging for the End User

# Packages & Functions on Display:
# - {shiny 1.7.3}: validate, need


# Concepts ----------------------------------------------------------------

# - Crafting validation errors to help end users correct issues during app use
# - These are not necessarily errors for the R programmers creating the application
# - Sanitizing error messages for security purposes

# Note:
# It is recommended to create validation steps that "fail fast" and in a useful
# way. This means you should structure your app in such a way as to validate the
# input before any heavy processing is done. One way to do this is to Test
# reactive inputs individually before they are used elsewhere

# Online Documentation:
# https://shiny.rstudio.com/articles/validation.html
# https://shiny.rstudio.com/articles/sanitize-errors.html

# https://mastering-shiny.org/
# https://shiny.rstudio.com/articles/

# Setup -------------------------------------------------------------------

library(shiny)


options(shiny.sanitize.errors = F)    # See detailed error message in UI
# options(shiny.sanitize.errors = T)  # See generic error message in UI


# User Interface ----------------------------------------------------------

ui <- fluidPage(

  titlePanel("Old Faithful Geyser Data"),

  sidebarLayout(
    sidebarPanel(
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30)
    ),

    mainPanel(
      plotOutput("distPlot")
    )
  )
)

# Server Operations -------------------------------------------------------

server <- function(input, output) {

  # Here we are passing a plot to renderTable, and the UI shows an error. This
  # error might make sense to us, the R programmer, but the end user may not
  # know how to handle this error

  output$distPlot <- renderTable({

    x    <- faithful[ , 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)

    result <-
      hist(x, breaks = bins, col = 'darkgray', border = 'white',
           xlab = 'Waiting time to next eruption (in mins)',
           main = 'Histogram of waiting times')

    # Validation Checks ---
    # validate(
    #  need(expr    = is.data.frame(result),               # This expr must evaluate to T/F
    #       message = "This step requires a dataframe."),  # Message to display when expr is F
    #
    #  need(is.numeric(x),
    #       "This step requires numeric values"),
    #
    #  need(1 == 2,
    #       "Contact your local Shiny developer, something has gone wrong.")
    # )
    #
    # return(result)

  })
}


# Run Application ---------------------------------------------------------

shinyApp(ui = ui, server = server)
