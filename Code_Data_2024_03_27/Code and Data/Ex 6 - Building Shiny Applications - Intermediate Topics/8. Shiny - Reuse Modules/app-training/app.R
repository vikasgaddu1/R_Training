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

# We must source the R script containing the Shiny modules

library(shiny)
source("../saved-modules.R")


# User Interface ----------------------------------------------------------

ui <- fluidPage(

  sidebarLayout(
    sidebarPanel(

      # We call our module functions with custom arguments
      sampleUI(
        id      = "sample-module-id",
        label_1 = "Select a Character",
        label_2 = "Select a Number")),

    mainPanel(
      textOutput("result")
    )
  )
)

# Server Operations -------------------------------------------------------


server <- function(input, output) {

  # Call our server module with custom arguments, and assign it to `output$...`
  output$result <- renderPrint({
    sampleServer(id = "sample-module-id", label_3 = "My Module") |>
      cat()
  })
}


# Run Application ---------------------------------------------------------

shinyApp(ui = ui, server = server)
