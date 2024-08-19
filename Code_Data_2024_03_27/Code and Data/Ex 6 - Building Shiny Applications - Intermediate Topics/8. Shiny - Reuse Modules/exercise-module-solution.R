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

selectionUI <- function(id, data, multiple = T){
  namespace_link <- NS(id)
  tagList(
    varSelectInput(
      inputId  = namespace_link("select_vars"),
      label    = "Select Variables",
      data     = data,
      selected = colnames(data),
      multiple = multiple
    )
  )
}

selectionServer <- function(id, data){
  moduleServer(id, module = function(input, output, session){
    my_vars <- as.character(input$select_vars)
    data[my_vars]
  })
}
