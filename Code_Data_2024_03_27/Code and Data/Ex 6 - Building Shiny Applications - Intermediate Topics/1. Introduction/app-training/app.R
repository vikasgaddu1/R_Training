# Anova Accel2R - Clinical R Training -----------------------------------
# © 2023 Anova Groups All rights reserved

# Title: Introduction to Building Shiny Applications

# Setup -------------------------------------------------------------------

data_path <- "../../_data"

library(dplyr)
library(readr)
library(shiny)
library(plotly)
library(crosstalk)
library(shinydashboard)

enableBookmarking("server")


# User Interface ----------------------------------------------------------

ui <- function(request){

  dashboardPage(

    dashboardHeader(
      title = "Building Shiny Applications",
      titleWidth = "300px"),

    dashboardSidebar(
      width = "300px",

      h4("Tabbed Pages"),
      sidebarMenu(
        id = "sidebar-menu",
        menuItem("Page 1", tabName = "tab-summary", icon = icon("chart-simple")),
        menuItem("Page 2", tabName = "tab-details", icon = icon("table"))),

      hr(),

      h4("Dynamic Output"),
      selectInput(
        inputId = "choose_view",
        label   = "Choose a View",
        choices = c("None", "Vector", "Table", "Plot")),

      hr(),

      h4("Dynamic Input"),
      radioButtons(
        inputId = "buttons",
        label   = "Select Input:",
        choices = c("Slider", "Check Box", "Text Box")),

      conditionalPanel(
        condition = "input.buttons == 'Slider'",
        sliderInput(
          "new_slide",
          "Select a Number",
          min = 1, max = 5, value = 1)),

      conditionalPanel(
        condition = "input.buttons == 'Check Box'",
        checkboxGroupInput(
          "new_checkbox",
          "Select a Type",
          choices = c("Box 1", "Box 2", "Box 3"))),

      conditionalPanel(
        condition = "input.buttons == 'Text Box'",
        textInput("new_text", "Text Selection")),

      hr(),

      h4("Save & Restore User Selections"),
      bookmarkButton(label = "Save Bookmark..."),

      hr()
    ),

    dashboardBody(
      tabItems(
        tabItem(
          tabName = "tab-summary",

          fluidRow(
            box(
              width  = 12,
              title  = "Dynamic Output",
              footer = "This output type changes based on user selection.",
              uiOutput("dynamic_view"))),

          fluidRow(
            box(width = 6, title = "Linking Output", plotlyOutput("plotly_1")),
            box(width = 6, title = "Linking Output", plotlyOutput("plotly_2")))),

        tabItem(
          tabName = "tab-details",

          fluidRow(
            box(
              width = 6,
              title = "Reactive Control",
              selectInput("file_select", "Select File", choices = dir(data_path)),
              actionButton("data_import", "Import Selected File")
            ),
            box(
              width = 6,
              title = "UI for End User",
              actionButton(inputId = "launch_button", "Launch Process")
            )),

          fluidRow(
            box(
              width = 12,
              title = "Reactive Control",
              plotOutput("plot_reactive"))))
      )
    )
  )
}

# Server Operations -------------------------------------------------------

server <- function(input, output, session) {

  # Demonstrate Dynamic UI ----

  output$dynamic_view <- renderUI({
    if (input$choose_view == "Vector"){
      renderText(mtcars$mpg)
    } else if (input$choose_view == "Table"){
      renderTable(mtcars[1:5, 1:5])
    } else if (input$choose_view == "Plot"){
      renderPlot(
        plot(mtcars[c("mpg", "disp")])
      )}
  })


  # Demonstrate Crosstalk ----

  df_crosstalk <-
    iris |>
    rowwise() |>
    mutate(data_key = paste0(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width)) |>
    SharedData$new(key = ~data_key)

  output$plotly_1 <- renderPlotly({
    df_crosstalk |>
      plot_ly(x = ~Sepal.Length, y = ~Sepal.Width, color = ~Species) |>
      add_markers() |>
      highlight(on = "plotly_selected", off = "plotly_deselect") |>
      hide_legend() |>
      config(displayModeBar = F)
  })

  output$plotly_2 <- renderPlotly({
    df_crosstalk |>
      plot_ly(x = ~Petal.Length, y = ~Petal.Width, color = ~Species) |>
      add_markers() |>
      highlight(on = "plotly_selected", off = "plotly_deselect") |>
      hide_legend() |>
      config(displayModeBar = F)
  })


  # Demonstrate Reactive Flow ----

  init <- reactiveValues(show_output = F)

  observeEvent(input$file_select, {
    init$show_output <- F
  })

  observeEvent(input$data_import, {
    init$show_output <- T
  })

  df_import <- eventReactive(input$data_import, {
    read_csv(
      file.path(data_path, input$file_select),
      show_col_types = F,
      progress = F)
  })

  output$plot_reactive <- renderPlot({
    if (init$show_output){df_import() |> plot()} else {return()}
  })


  # Demonstrate UI Helpers ----
  observeEvent(input$launch_button, {
    showModal(modalDialog(
      title = "Warning",
      "You are about to launch the process!",
      footer = tagList(
        actionButton(inputId = "confirm_button", "Continue"),
        modalButton("Cancel"))))
  })

  observeEvent(input$confirm_button, {
    removeModal()
    withProgress(message = "Processing...", {
      n_runs <- 5
      for(i in 1:n_runs){
        Sys.sleep(1)
        incProgress(amount = 1 / n_runs, detail = paste("Increment", i))}})

    showNotification(
      ui = "The process is complete.",
      type = "message",  # types: default, message, warning, error
      duration = 5)
  })

}


# Run Application ---------------------------------------------------------

shinyApp(ui = ui, server = server)
