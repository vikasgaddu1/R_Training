# Anova Accel2R - Clinical R Training -----------------------------------
# © 2023 Anova Groups All rights reserved

# Title: Shiny - Building Reusable Modules

# Packages & Functions on Display:
# - {shiny 1.7.3}: moduleServer, NS


# Concepts ----------------------------------------------------------------

# Shiny modules are pieces of Shiny apps that can be reused. They are like
# functions in R, meaning you can store them in an R script or in an R Package
# and easily share them to be used by others

# Modules can include both inputs and outputs
# Modules can be used to make a complex application easier to develop and test

# Online Documentation
# https://shiny.rstudio.com/articles/modules.html
# https://shiny.rstudio.com/articles/communicate-bet-modules.html

# Setup -------------------------------------------------------------------

library(shiny)


# Creating a Module -------------------------------------------------------

# Notes:
# - Modules should always end with either `Input`, `Output`, `UI`, or `Server`
# - Module functions should always have `id` as their first argument
# - The `id` argument is used to link the module to the overall application


sampleUI <- function(id, label_1, label_2){


  # Notes:
  # - Use NS to create the "Namespace Link" between module and app
  # - This function is used for inputId names
  # - These input and output assignments need to be unique within the module,
  #  not the entire app

  namespace_link <- NS(id)

  # Must use tagList when defining multiple Shiny elements
  tagList(
    h2("Demonstrating a Module"),
    selectInput(
      inputId = namespace_link("select_chr"),
      label   = label_1,
      choices = c("A", "B", "C")),
    hr(),
    radioButtons(
      inputId = namespace_link("select_num"),
      label   = label_2,
      choices = c(1, 2, 3)
    )
  )
}


# Now we define the corresponding server module
# This function definition should start with id, and then include custom arguments

sampleServer <- function(id, label_3){

  # All Shiny modules start with this moduleServer definition
  moduleServer(id, module = function(input, output, session){

    # Once we are inside the moduleServer, then we include our customized operations,
    # this is mostly similar to how you typically define operations in the server portion
    # of a Shiny app

    result <-
      stringr::str_glue(
        .sep = " ",
        "For the process '{label_3}',",
        "you chose {input$select_chr} and {input$select_num}.")

    # Notice that we must return an output here, like a typical R function
    # We do not make the Shiny `output$...` assignment inside the module function
    return(result)

  })
}
