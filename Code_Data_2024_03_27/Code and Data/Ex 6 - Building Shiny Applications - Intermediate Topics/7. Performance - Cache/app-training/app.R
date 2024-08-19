# Anova Accel2R - Clinical R Training -----------------------------------
# © 2023 Anova Groups All rights reserved

# Title: Shiny Performance - Caching Results

# Packages & Functions on Display:
# - {shiny 1.7.3}: bindCache


# Concepts ----------------------------------------------------------------

# The bindCache function will store hashed results to disk and load them when
# the same combination of dependencies are selected by the user.
#
# By default the cache is shared with all users of the running application, this
# means that all users can benefit from improved load times after one user has
# clicked through the app.
# - This behavior can be modified with the 'cache' argument in bindCache
#
# See the following online documentation for more information on finer control
# over cache scoping rules, and tips on how to use bindCache when deploying a
# Shiny app on a server like `Posit Connect` or `shinyapps.io`

# Documentation:
# https://shiny.rstudio.com/articles/caching.html

# Setup -------------------------------------------------------------------

library(shiny)


# User Interface ----------------------------------------------------------

ui <- fluidPage(

  titlePanel("Cached Results"),

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
  #
  # bindCache takes the reactive we want to speed up,
  # and the unique keys to identify this cache
  #
  # - Note that caching on bins may not be ideal
  #  because it'll create a new cache for every possible numeric value
  #
  # - But caching on color will save us time and space
  #  because there are only three options

  my_bin <- reactive({input$bins})  |> bindCache(input$bins)
  my_col <- reactive({input$color}) |> bindCache(input$color)


  # Prepare Output ---
  #
  # We can choose to bindCache either on reactive functions alone, or on render
  # functions.  This may be beneficial when rendering may take a long time to
  # complete, like with large tables and plots
  #
  # Notice here we're using bindCache with both reactive dependencies.
  # - There can be cache confusion if you omit any dependencies
  #  that can uniquely identify this cached result

  output$message <- renderText({
    paste("You chose the color", my_col(),
          "with", my_bin(), "bins.")
    }) |> bindCache(my_bin(), my_col())


  # And in this case, we're just demonstrating that this can include input$ values
  # - Note that cached plots may have trouble resizing when being loaded on
  #  different systems and different displays.
  # - Read the documentation for more info on handling cached plot displays

  output$distPlot <- renderPlot({
    hist(df,
         breaks = seq(min(df), max(df), length.out = my_bin() + 1),
         col = my_col(), border = 'white',
         xlab = 'Waiting time to next eruption (in mins)',
         main = 'Histogram of waiting times')
  }) |> bindCache(input$bins, input$color)
}


# Run Application ---------------------------------------------------------

shinyApp(ui = ui, server = server)
