# Anova Accel2R - Clinical R Training -----------------------------------
# © 2023 Anova Groups All rights reserved

# Title: Shiny UI - Dynamic Interfaces - Part II

# Packages & Functions on Display:
# - {shiny 1.7.3}: conditionalPanel, renderUI, uiOutput



# Concepts ----------------------------------------------------------------

# - Using renderUI and uiOutput to control how UI elements change
# - Using conditionalPanel to add UI elements based on other UI conditions


# Note
# This lesson is a follow up to the "Dynamic Shiny" lesson in the first "Shiny
# and R Markdown" course. That lesson focused on the `update` and `observeEvent`
# functions


# Online Documentation
# https://shiny.rstudio.com/articles/dynamic-ui.html


# Setup -------------------------------------------------------------------

library(shiny)

# User Interface ----------------------------------------------------------

ui <- fluidPage(

    titlePanel("Dynamic Shiny Interfaces"),

    sidebarLayout(

        sidebarPanel(

            # Concept 1: Using renderUI
            HTML("<h4> Using <code>renderUI</code> </h4>"),
            selectInput(
                inputId = "choose_view",
                label   = "Choose a View",
                choices = c("None", "Vector", "Table", "Plot")),
            hr(),


            # Concept 2: Using conditionalPanel
            HTML("<h4> Using <code>conditionalPanel</code> </h4>"),
            radioButtons(
                inputId = "buttons",
                label   = "Select a new input type:",
                choices = c("None", "Slider", "Check Box", "Text Box")),
            hr(),

            # Note, this condition MUST be in the JavaScript language
            # Notice the format here of `input.{inputId}`
            # where the output is quoted with a single quote

            conditionalPanel(
                condition = "input.buttons == 'Slider'",
                sliderInput(
                    "new_slide",
                    "Here's a slider",
                    min = 1, max = 5, value = 1)),

            conditionalPanel(
                condition = "input.buttons == 'Check Box'",
                checkboxGroupInput(
                    "new_checkbox",
                    "Here's a check box",
                    choices = c("Box 1", "Box 2", "Box 3"))),

            conditionalPanel(
                condition = "input.buttons == 'Text Box'",
                textInput("new_text", "Here's a text box"))),

        mainPanel(
            wellPanel(
                h2("Chosen View"),
                uiOutput("dynamic_view")
            )
        )
    )
)

# Server Operations -------------------------------------------------------


server <- function(input, output) {

    output$dynamic_view <- renderUI({

        if (input$choose_view == "Vector"){

            renderText(mtcars$mpg)

        } else if (input$choose_view == "Table"){

            renderTable(mtcars[1:5, 1:5])

        } else if (input$choose_view == "Plot"){

            renderPlot(
                plot(mtcars[c("mpg", "disp")])
            )
        }

    })

}


# Run Application ---------------------------------------------------------

shinyApp(ui = ui, server = server)
