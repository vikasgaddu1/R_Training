# Anova Accel2R - Clinical R Training -----------------------------------
# © 2023 Anova Groups All rights reserved

# Title: Shiny Reactions - Reset Output

# Packages & Functions on Display:
# - {shiny 1.7.3}: reactiveValues, observeEvent, eventReactive


# Concepts ----------------------------------------------------------------

# How can we set up our Shiny application so that the UI resets whenever changes
# are made to the input values?  We can use the various `reactive` functions to
# control when and how the UI updates, along with removing output when input
# selections are changed
#
# This lesson will provide a greater overview of how the different `reactive`
# functions operate
#

# Documentation:
# https://shiny.rstudio.com/articles/isolation.html
# https://shiny.rstudio.com/articles/reactivity-overview.html
# https://shiny.rstudio.com/articles/execution-scheduling.html
# https://shiny.rstudio.com/articles/understanding-reactivity.html
# https://mastering-shiny.org/reactivity-objects.html#observeevent-and-eventreactive

# Setup -------------------------------------------------------------------

library(shiny)
library(ggplot2)

# User Interface ----------------------------------------------------------

ui <- fluidPage(

  titlePanel("Shiny Reactions - Reset Output"),

  sidebarLayout(
    sidebarPanel(
      varSelectInput(
        inputId  = "select_var",
        label    = "Select a Variable",
        data     = diamonds,
        multiple = F),
      selectInput(
        inputId = "select_view",
        label   = "Select a View",
        choices = c("Plot", "Summary", "Text")
      ),
      actionButton(
        inputId = "select_button",
        label   = "Submit Selections"
      )
    ),

    mainPanel(
      h3("Plot Output"),
      plotOutput("out_plot"),
      hr(),
      h3("Summary Output"),
      verbatimTextOutput("out_table"),
      hr(),
      h3("Text Output"),
      textOutput("out_text")
    )
  )
)

# Server Operations -------------------------------------------------------

server <- function(input, output) {

  init <- reactiveValues(show_output = F)

  observeEvent(input$select_var, {
    init$show_output <- F
  })

  observeEvent(input$select_view, {
    init$show_output <- F
  })

  observeEvent(input$select_button, {
    init$show_output <- T
  })


  output$out_plot <- renderPlot({
    if (init$show_output && input$select_view == "Plot"){
      diamonds[[input$select_var]] |> plot()
    } else {
      return()
    }
  })

  output$out_table <- renderPrint({
    if (init$show_output && input$select_view == "Summary"){
      diamonds[[input$select_var]] |> summary()
    } else {
      cat() # (this is a substitute for an empty result)
    }
    })

  output$out_text <- renderText({
    if (init$show_output && input$select_view == "Text"){
    paste("The variable", input$select_var,
          "is of type",
          typeof(diamonds[[input$select_var]]))
    } else {
      return()
    }
  })
}


# Run Application ---------------------------------------------------------

shinyApp(ui = ui, server = server)
