# Anova Accel2R - Clinical R Training -----------------------------------
# © 2023 Anova Groups All rights reserved

# Title: Shiny Reactions - Controlling Updates

# Packages & Functions on Display:
# - {shiny 1.7.3}: isolate, eventReactive


# Concepts ----------------------------------------------------------------

# Isolate works in a way that is similar to eventReactive, but allows for some
# flexibility in how to code it.  Using isolate is beneficial when you are using
# the reactive values only once, and don't necessarily need to turn each UI
# dependent value into a reactive value

# In general, you may not need to use isolate() on its own, because its works in
# a similar way as eventReactive and observeEvent. However, it is good to know
# how this works for those cases that you may need finer control

# Online Documentation
# https://shiny.rstudio.com/articles/isolation.html
# https://mastering-shiny.org/reactive-motivation.html
# https://shiny.rstudio.com/articles/execution-scheduling.html
# https://shiny.rstudio.com/articles/understanding-reactivity.html


# Setup -------------------------------------------------------------------

library(shiny)


# User Interface ----------------------------------------------------------

ui <- fluidPage(

  titlePanel("Old Faithful Geyser Data"),

  sidebarLayout(
    sidebarPanel(

      sliderInput(
        inputId = "select_bins",
        label   = "Number of bins:",
        min     = 1,
        max     = 50,
        value   = 30),

      radioButtons(
        inline  = T,
        inputId = "select_color",
        label   = "Select a color:",
        choices = c("Gray"    = "darkgray",
                    "Blue"    = "lightblue",
                    "Orange"  = "orange")),

      hr(),

      actionButton(
        inputId = "action_button",
        label   = "Rebuild Plot")
    ),

    mainPanel(
      plotOutput("distPlot")
    )
  )
)

# Server Operations -------------------------------------------------------

server <- function(input, output) {


  # No Reactive Isolation ------------------------------------------------------

  output$distPlot <- renderPlot({

    df    <- faithful[, 2]

    n_bins  <- seq(min(df), max(df), length.out = input$select_bins + 1)
    h_color <- input$select_color

    df |>
      hist(breaks = n_bins, col = h_color, border = 'white',
           xlab = 'Waiting time to next eruption (in mins)',
           main = 'Histogram of waiting times')
  })



  # With Reactive Isolation ----------------------------------------------------
  # In this case, we can use a single isolate call inside of the render function
  # This is beneficial if we will not depend on n_bins or h_color elsewhere in app


  # output$distPlot <- renderPlot({
  #
  #  # Remember action buttons are initialized at 0
  #  if (input$action_button == 0) {
  #
  #    # When the button hasn't been pressed, return an empty plot
  #    return()
  #
  #  } else {
  #
  #  df    <- faithful[, 2]
  #
  #  # The isolate function can wrap multiple operations
  #  isolate({
  #    n_bins  <- seq(min(df), max(df), length.out = input$select_bins + 1)
  #    h_color <- input$select_color
  #  })
  #
  #  df |>
  #    hist(breaks = n_bins, col = h_color, border = 'white',
  #         xlab = 'Waiting time to next eruption (in mins)',
  #         main = 'Histogram of waiting times')
  #
  #  }
  #
  # })



  # Similar operation with eventReactive ---------------------------------------
  # In this case, we need to create multiple reactive values (n_bins, h_color)
  # This is beneficial if we are going to be reusing these values elsewhere


  # df    <- faithful[, 2]
  #
  # n_bins  <- eventReactive(
  #  input$action_button,
  #  seq(min(df), max(df), length.out = input$select_bins + 1))
  #
  # h_color <- eventReactive(
  #  input$action_button,
  #  input$select_color)
  #
  #
  # output$distPlot <- renderPlot({
  #  df |>
  #    hist(breaks = n_bins(), col = h_color(), border = 'white',
  #         xlab = 'Waiting time to next eruption (in mins)',
  #         main = 'Histogram of waiting times')
  # })

}


# Run Application ---------------------------------------------------------

shinyApp(ui = ui, server = server)
