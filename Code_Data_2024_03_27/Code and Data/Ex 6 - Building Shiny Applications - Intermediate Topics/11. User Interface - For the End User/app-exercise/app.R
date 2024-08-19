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
library(ggplot2)


# User Interface ----------------------------------------------------------

ui <- fluidPage(
    titlePanel("Shiny UI For the End User"),
    sidebarLayout(
        sidebarPanel(
            varSelectInput(
                inputId  = "select_variable",
                label    = "Select a Variable",
                data     = diamonds,
                multiple = F),
            actionButton(
                inputId = "button_popup",
                label   = "Choose an action...")),
        mainPanel(
            uiOutput("my_result")
        )))

# Server Operations -------------------------------------------------------

server <- function(input, output) {

    observeEvent(input$button_popup,{
        showModal(
            modalDialog(
                title = "Choose Output Type",
                radioButtons(
                    inputId = "chosen_view",
                    label   = "What type of output do you want to see?",
                    choices = c("Table", "Plot", "Text")),
                footer = tagList(
                    actionButton(inputId = "confirm_button", "Submit"),
                    modalButton("Cancel"))
            )
        )
    })

    observeEvent(input$confirm_button, {

        # Close window when button is pressed
        removeModal()

        # Dispay blue notification that does not disappear on its own
        showNotification("Submission received!", duration = NULL, type = "message")

        # Progress simulation
        withProgress(
            message = "Processing...",
            min   = 0,
            max   = 1,
            value = 1,
            expr  = Sys.sleep(2))

        # Processing
        output$my_result <- renderUI({
            if(input$chosen_view == "Table"){

                renderTable(
                    diamonds[input$select_variable] |>
                        head()
                )

            } else if (input$chosen_view == "Plot"){

                renderPlot({
                    diamonds[[input$select_variable]] |> ggplot2::qplot()
                })

            } else if (input$chosen_view == "Text"){
                renderText(
                    paste("The variable",
                          input$select_variable,
                          "is of type",
                          paste(
                              diamonds[[input$select_variable]] |> class(),
                              collapse = " and "))
                )
            }
        })
    })
}


# Run Application ---------------------------------------------------------

shinyApp(ui = ui, server = server)
