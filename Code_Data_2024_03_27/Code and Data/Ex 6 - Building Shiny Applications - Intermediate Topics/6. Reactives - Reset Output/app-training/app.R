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
data_path <- "../../_data"


# User Interface ----------------------------------------------------------

ui <- fluidPage(

  titlePanel("Resetting Reactions"),

  sidebarLayout(
    sidebarPanel(
      selectInput("file_select", "Select File", choices = dir(data_path, pattern = "*.csv")),
      actionButton("data_import", "Import Selected File")),

    mainPanel(
      plotOutput("plot")
    )
  )
)

# Server Operations -------------------------------------------------------

server <- function(input, output) {

  # Set an initial value that will depend on user input, thus we use reactiveValues
  # Here, when we start the app we do not want to display the plot
  init <- reactiveValues(
    show_output = F
  )


  # When we observe any changes in the file_select input, we set 'show_output' to F
  observeEvent(input$file_select, {
    init$show_output <- F
  })

  # When we observe any changes in the data_import button, we set 'show_output' to T
  observeEvent(input$data_import, {
    init$show_output <- T
  })


  # eventReactive can be used with assignment, but observeEvent cannot
  # When the 'data_import' button is pressed, we read the data and store it for later
  df_import <- eventReactive(input$data_import, {
    readr::read_csv(
      file.path(data_path, input$file_select),
      show_col_types = F,
      progress = F)
  })


  # Now we use our reactive logic to determine when to display the plot
  output$plot <- renderPlot({

    if (init$show_output){
      df_import() |> plot()
    } else {
      # Returning an empty result translates to a blank UI display
      return()
    }

  })
}


# Run Application ---------------------------------------------------------

shinyApp(ui = ui, server = server)
