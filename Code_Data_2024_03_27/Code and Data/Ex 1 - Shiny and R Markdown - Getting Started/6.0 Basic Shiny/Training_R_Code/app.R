
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Shiny Application Layout

# Packages & Functions on Display:
# - {shiny 1.6.0}:  fluidPage, sidebarLayout, sidebarPanel, titlePanel,
#                  mainPanel, fluidRow, column, wellPanel, shinyApp


# Setup -------------------------------------------------------------------

# Load Packages
library(shiny)
library(tidyverse)


# Shiny Template ----------------------------------------------------------

# Six Lines for Every Shiny App ----
# library(shiny)
#
# ui     <- shiny::fluidPage()
# server <- function(input, output, session) {}
#
# shiny::shinyApp(ui, server)


# Shiny:
# - Uses a typical R Script
# - No more R Markdown formatting or shortcuts for HTML
# - User Interface contains all display and output
# - Server contains all R computation


# RStudio:
# - 'Run App' instead of 'Run Document' or 'Knit'
# - Document is not 'portable'
# - Application uses temporary or permanent server
# - R console is 'busy' while application is running
# - Recommended to use informative headers in code, and use document outline


# Creating New Application
# - File > New > Shiny Web App


# 'Run App' Options
# - Display application output in viewer, pop-up window, or in browser
# - Run the application using either the interactive R console, or as a background job
#  - A background job would allow you to continue using R normally, while application
#    is running
# - Record / Run Tests allow you to set up cpu/memory/debug tests on your Shiny app



# User Interface ----------------------------------------------------------

ui <- fluidPage(
  titlePanel("Learning to Create a Shiny App"),
  
  # Use Sidebar Layout for Entire App
  # Alternatives include fillPage, fixedPage, flowLayout, fluidPage, navbarPage
  sidebarLayout(
    
    ## Sidebar Panel ----
    sidebarPanel(
      
      "In Shiny, text must be provided as strings",
      shiny::h4("But there are Shiny HTML Shortcuts"),           # Header Level 4
      shiny::h5("See the htmltools package for more info"),      # Header Level 5
      shiny::p("You can create a new paragraph"),                # New Paragraph
      shiny::strong("Format as bold,"),                          # Strong/Bold Format
      shiny::em("italic,"),                                      # Emphasis/Italic Format
      shiny::code("or code"),                                    # Code Format
      shiny::br(),                                               # Line Break
      shiny::HTML("Or <b>use</b> <i>HTML</i> tags"),             # HTML Tag Format
      shiny::hr(),                                               # Horizontal Rule
      
      shiny::h4("Create User Input Methods using Shiny or HTML"),
      selectInput(
        inputId = 'select_input',
        label = "Shiny: Select Input",
        choices = c("A", "B", "C")),
      
      shiny::hr(),
      shiny::HTML('<div><label class="control-label" id="select_input-label" for="select_input">HTML: Select Input</label>
                            <div><select id="select_input"><option value="First Choice"  selected>First Choice</option>
                            <option value="Second Choice">Second Choice</option><option value="Third Choice">Third Choice</option>
                            </select><script type="application/json" data-for="select_input" data-nonempty="">
                            {"plugins":["selectize-plugin-a11y"]}</script></div></div>')
    ),
    
    ## Main Panel ----
    mainPanel(
      
      "Break Panel into Rows and Columns of Output" %>% shiny::h4(),
      
      shiny::fluidRow(
        shiny::column(width = 2, shiny::wellPanel('Width 2')),
        shiny::column(width = 4, shiny::wellPanel('Width 4')),
        shiny::column(width = 6, shiny::wellPanel('Width 6'))
      ),
      
      hr(),
      
      shiny::fluidRow(
        shiny::column(width = 12, shiny::wellPanel('Width 12'))
      ),
      
      hr(),
      tabsetPanel(
        tabPanel(title = "Tab 1", "Use tabs like fluidRow", p("Just keep using commas to add more content")),
        tabPanel(title = "Tab 2", wellPanel("This could include panels, columns, shiny input, or shiny output")),
        tabPanel(title = "Tab 3", column(4, wellPanel()), column(4, wellPanel()), column(4, wellPanel()))
      ),
      
      hr(),
      "Shiny Server Functions" %>% shiny::h4(),
      
      shiny::selectInput(
        inputId  = 'select_vars_for_table',
        label    = 'Select Some Variables',
        choices  = colnames(mtcars),
        multiple = TRUE),
      
      DT::dataTableOutput("dt_table_output"),
      hr()
    )
  )
)

# Define the Server -------------------------------------------------------
# Recall the five steps of Shiny processing
# 1. The selection input is rendered in HTML on the user interface
# 2. Create reactive context to capture user input 'events'
# 3. Create reactive context that depends on 'events' generated by user input
# 4. Renders the object and places it in the output 'buffer' temporarily
# 5. Push rendered object to user interface from output buffer

server <- function(input, output, session) {
  
  # 1. Done using Shiny Input functions in UI
  
  # 2. Capture user events in reactive context
  vars_selected_by_user <- reactive(input$select_vars_for_table)
  
  # 3. Use user input in other reactive process
  datatable_to_display  <- reactive({
    mtcars %>%
      select(one_of(vars_selected_by_user())) %>%
      DT::datatable(options = list(pageLength = 3))
  })
  
  # 4. Render the object and place in output buffer
  output$dt_table_output <- DT::renderDataTable(datatable_to_display())
  
  # 5. Done using Shiny Output functions in UI
  
}


# Run the Application -----------------------------------------------------

shinyApp(ui, server)

# Documentation -----------------------------------------------------------

# Single Page Layouts:  https://mastering-shiny.org/action-layout.html#layout
# Multiple Page Layout: https://mastering-shiny.org/action-layout.html#multi-page-layouts

# - Site: RStudio Shiny Cheatsheet     https://rstudio.com/resources/cheatsheets/
# - Site: RStudio Shiny Reference      https://shiny.rstudio.com/reference/shiny/1.6.0/
# - Site: RStudio Shiny Tutorial       https://shiny.rstudio.com/tutorial/
# - Book: Mastering Shiny              https://mastering-shiny.org/

# -------------------------------------------------------------------------
