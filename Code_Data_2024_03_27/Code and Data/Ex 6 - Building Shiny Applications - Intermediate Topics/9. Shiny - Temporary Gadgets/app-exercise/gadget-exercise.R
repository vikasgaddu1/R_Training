# Anova Accel2R - Clinical R Training -----------------------------------
# © 2023 Anova Groups All rights reserved

# Title: Shiny - Building Temporary Gadgets

# Packages & Functions on Display:
# - {miniUI 0.1.1.1}: miniPage, gadgetTitleBar, miniContentPanel
# - {shiny  1.7.3  }: runGadget, paneViewer, stopApp


# Concepts ----------------------------------------------------------------

# Shiny gadgets are interactive tools that are meant to be used in the course of
# analysis.  Another way to say this is that Shiny Gadgets are meant to be used
# by R users, whereas Shiny Apps are meant to be used by end users that don't
# necessarily know how to use R

# Shiny gadgets are only meant to be used interactively in a script or by using
# the RStudio Addins menu

# Gadgets are defined in a typical R function, unlike Shiny apps which must be
# defined in a standalone 'app.R' script

# For gadgets, we use `miniUI` in addition to `shiny`, which provides an
# interface suitable for running in the RStudio viewer panel

# In order to register this gadget function as an RStudio Addin, we must include
# the finalized function in a package that then gets installed in RStudio


# Online Documentation
# https://shiny.rstudio.com/articles/gadgets.html
# https://shiny.rstudio.com/articles/gadget-ui.html

# Setup -------------------------------------------------------------------

library(shiny)
library(miniUI)


# Gadget Interface --------------------------------------------------------

fn_gadget_exercise <- function(data){

    runGadget(
        ## UI ----
        viewer = dialogViewer(dialogName = "Shiny Gadget"),
        app    = miniPage(

            gadgetTitleBar("Gadget: Data Exploration"),
            miniContentPanel(
                varSelectInput(
                    inputId = "select_variable",
                    label   = "Select a Variable to Explore",
                    data    = data),

                varSelectInput(
                    inputId  = "saved_variables",
                    label    = "Select Variables to Save",
                    data     = data,
                    multiple = T),

                hr(),
                plotOutput("plot")

            )
        ),

        ## Server ----
        server = function(input, output, session){
            output$plot <- renderPlot({
                data[[input$select_variable]] |> plot()
            })

            observeEvent(input$done, {
                assign(
                    "my_variables",
                    value = as.character(input$saved_variables),
                    envir = .GlobalEnv)

                stopApp({
                    cat("Storing your selected variables in the global environment as `my_variables`")
                })
            })
        }
    )
}


# Test Gadget -------------------------------------------------------------

mtcars |> fn_gadget_exercise()
