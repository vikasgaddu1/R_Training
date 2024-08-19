
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Dynamic Shiny Interface

# Packages & Functions on Display:
# - {shiny 1.6.0}: observeEvent, update*
# - {fs    1.5.0}: dir_ls


# Setup -------------------------------------------------------------------

# Load Packages
library(fs)
library(shiny)
library(tidyverse)

# Data Directory
data_path <- "../../data"    # Path for Shiny App

# Shiny Template ----------------------------------------------------------
# Six Lines for Every Shiny App

# library(shiny)
#
# ui     <- shiny::fluidPage()
# server <- function(input, output, session) {}
#
# shiny::shinyApp(ui, server)


# User Interface ----------------------------------------------------------

ui <- shiny::fluidPage(
  titlePanel("Controlling Dynamic Shiny Interfaces"),

  sidebarLayout(
    sidebarPanel(

      ## Import Data ----
      selectInput(
        inputId  = "select_data",
        label    = "Select an Input Dataset",
        choices  = fs::dir_ls(data_path, glob = "*.csv"),
        selected = NULL),
      actionButton(
        inputId = "import_data",
        label   = "1. Import Dataset"),
    ),

    mainPanel(

      fluidRow(
        column(width = 12, wellPanel(

          ## Import Message ----
          htmlOutput("import_message")

        ))
      ),

      hr(),
      fluidRow(
        column(width = 6, wellPanel(

          ## Select Variables ----
          selectInput(inputId  = "select_vars",
                      label    = "2. Select Some Variables",
                      choices  = NULL,
                      multiple = TRUE)

        )),

        ## Generate Results ----
        column(width = 6, wellPanel(
          actionButton(inputId = "use_vars",
                       label   = "First, Select Some Data")
        ))
      ),

      ## Variable Summary ----
      tabsetPanel(
        tabPanel("Summary", verbatimTextOutput("summary_output"))
      )
    )
  )
)

# Server ------------------------------------------------------------------

server <- function(input, output, session) {

  ## Import Data ----
  df_import <-
    eventReactive(input$import_data, {
      read_csv(input$select_data, progress = F, show_col_types = F)
    })

  ## Import Message ----
  output$import_message <- renderPrint(
    str_glue("You imported <b>{input$select_data}</b>,
             which has <i>{df_import() %>% nrow()}</i> observations
             and <i>{df_import() %>% ncol()}</i> variables.") %>%
      HTML()
  )


  ## Select Variables ----
  observeEvent(df_import(), {
    dynamic_colnames <- df_import() %>% colnames()
    updateSelectInput(
      inputId = "select_vars",
      choices = dynamic_colnames)
  })

  ## Generate Results ----
  observeEvent(df_import(), {
    updateActionButton(
      inputId = "use_vars",
      label   = "Second, Select Some Variables")
  })

  observeEvent(input$select_vars, {
    updateActionButton(
      inputId = "use_vars",
      label   = "3. Click to Get Summaries"
    )
  })


  ## Variable Summary ----
  df_variable_subset <-
    eventReactive(input$use_vars, {
      df_import() %>% select(one_of(input$select_vars))
    })

  output$summary_output <-
    renderPrint(df_variable_subset() %>% summary())

}


# Run the Application -----------------------------------------------------

shiny::shinyApp(ui, server)


# Documentation -----------------------------------------------------------

# - Site: https://mastering-shiny.org/action-dynamic.html
# - Site: https://shiny.rstudio.com/articles/dynamic-ui.html

# - Site: RStudio Shiny Cheatsheet     https://rstudio.com/resources/cheatsheets/)
# - Site: RStudio Shiny Reference      https://shiny.rstudio.com/reference/shiny/1.6.0/)
# - Site: RStudio Shiny Tutorial       https://shiny.rstudio.com/tutorial/)
# - Book: Mastering Shiny              https://mastering-shiny.org/)

# -------------------------------------------------------------------------
