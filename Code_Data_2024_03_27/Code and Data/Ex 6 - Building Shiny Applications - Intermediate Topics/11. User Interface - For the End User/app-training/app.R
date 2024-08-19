# Anova Accel2R - Clinical R Training -----------------------------------
# © 2023 Anova Groups All rights reserved

# Title: Shiny UI - For the End User

# Packages & Functions on Display:
# - {shiny 1.7.3}:  showModal, modalDialog, modalButton, removeModal,
#                  withProgress, incProgress, showNotification


# Concepts ----------------------------------------------------------------

# - Adding modal dialog popups
# - Adding progress indicators
# - Adding notifications

# Online Documentation:
# https://shiny.rstudio.com/articles/progress.html
# https://shiny.rstudio.com/articles/modal-dialogs.html
# https://shiny.rstudio.com/articles/notifications.html


# Setup -------------------------------------------------------------------

library(shiny)

# User Interface ----------------------------------------------------------

ui <- fluidPage(

  titlePanel("UI Helpers for the End User"),

  sidebarLayout(
    sidebarPanel(
      actionButton(inputId = "launch_button", "Launch Process")
    ),

    mainPanel(
      plotOutput("interesting_result")
    )
  )
)

# Server Operations -------------------------------------------------------


server <- function(input, output) {

  # Determine when to open the modal dialog window
  observeEvent(input$launch_button, {
    showModal(modalDialog(
      title = "Warning",
      "You are about to launch the process!",

      # Must use tagList when modifying popup actions
      footer = tagList(
        actionButton(inputId = "confirm_button", "Continue"),
        modalButton("Cancel"))
    ))
  })


  # With user confirmation, run the process
  observeEvent(input$confirm_button, {

    # Remove modal popup when confirm button is pressed
    removeModal()

    withProgress(message = "Processing...", {

      # Simulate long-running process
      n_runs <- 5

      for(i in 1:n_runs){
        Sys.sleep(1)
        incProgress(
          amount = 1 / n_runs,
          detail = paste("Increment", i))
      }
    })

    # Simulate an interesting result to return to UI
    output$interesting_result <- renderPlot(
      plot(mtcars[c("mpg", "disp")])
    )


    # Show a notification that the process is complete
    showNotification(
      ui = "The process is complete.",
      type = "message",  # types: default, message, warning, error
      duration = 5)

  })
}


# Run Application ---------------------------------------------------------

shinyApp(ui = ui, server = server)
