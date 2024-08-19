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

enableBookmarking("url")           # https://appname/_input_&n=50&color=blue
# enableBookmarking("server")      # https://appname/_state_id=abc123


# User Interface ----------------------------------------------------------

ui <- function(request){

  fluidPage(

    titlePanel("Bookmarked States"),

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
        bookmarkButton()
        ),

      mainPanel(
        textOutput("message"),
        hr(),
        plotOutput("distPlot")
      ))
  )}



# Server Operations -------------------------------------------------------


server <- function(input, output, session) {

  # Prepare Data ---
  df <- faithful$waiting

  # Process Input ---
  my_bin <- reactive({input$bins})  |> bindCache(input$bins)
  my_col <- reactive({input$color}) |> bindCache(input$color)

  # Prepare Output ---
  output$message <- renderText({
    paste("You chose the color", my_col(),
          "with", my_bin(), "bins.")
  })

  output$distPlot <- renderPlot({
    hist(df,
         breaks = seq(min(df), max(df), length.out = my_bin() + 1),
         col = my_col(), border = 'white',
         xlab = 'Waiting time to next eruption (in mins)',
         main = 'Histogram of waiting times')
  })
}


# Run Application ---------------------------------------------------------

shinyApp(ui = ui, server = server)
