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

library(readr)
library(shiny)
library(miniUI)


# Define the Function -----------------------------------------------------

fn_shiny_gadget <- function(data_path){

  file_list <- dir(data_path, full.names = T, pattern = "*.csv")

  runGadget(

    # viewer = paneViewer(),       # For viewer panel
    viewer = dialogViewer("Dialog Name"),   # For popup window
    # viewer = browserViewer(),  # For browser window

    # User Interface -------------------------
    miniPage(

      gadgetTitleBar("Gadget: Data Exploration"),

      miniContentPanel(

        selectInput(
          inputId = "file_selection",
          label   = "Select a file",
          choices = basename(file_list)),

        hr(),
        verbatimTextOutput("skim_result"),
        verbatimTextOutput("summary_result"),
        plotOutput("plot_result")
      )
    ),



    # Server Logic ---------------------------
    server = function(input, output, session){

      selected_file <- reactive({
        file.path(data_path, input$file_selection)
      })

      output$skim_result <- renderPrint({
        selected_file() |>
          readr::spec_csv()
      })

      output$summary_result <- renderPrint({
        selected_file() |>
          readr::read_csv(progress = F, show_col_types = F) |>
          summary()
      })


      # Define process when clicking "Done"
      observeEvent(input$done, {

        # Actions to take when "Done" button is clicked
        data_import <-
          selected_file() |>
          read_csv(progress = F, show_col_types = F)

        assign(
          "imported_data",
          value = data_import,
          envir = .GlobalEnv)

        stopApp({
          # Return values of interest
          cat("Importing data and closing gadget.")

        })
      })
    }
  )
}


# Test the Function -------------------------------------------------------

fn_shiny_gadget(
  data_path = "../_data"
)
