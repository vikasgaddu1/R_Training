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
library(dplyr)
library(ggplot2)

df_bmi <- readRDS("../../_data/bmi.rds")


# User Interface ----------------------------------------------------------

ui <- fluidPage(

    titlePanel("Dynamic Shiny Interfaces II - Exercises"),

    sidebarLayout(
        sidebarPanel(
            selectInput(
                inputId = "choose_view",
                label   = "Choose a View",
                choices = c("Raw", "Table", "Plot")),

            hr(),

            radioButtons(
                inputId = "filters",
                label   = "Do you want to filter the data?",
                choices = c("No Filters", "Filter Weight", "Filter Subject")
            ),


            conditionalPanel(
                condition = "input.filters == 'Filter Weight'",
                sliderInput(
                    inputId = "filter_weight",
                    label   = "Define Weight Filter",
                    min     = min(df_bmi$WEIGHT),
                    max     = max(df_bmi$WEIGHT),
                    value   = c(min(df_bmi$WEIGHT), max(df_bmi$WEIGHT))
                )
            ),

            conditionalPanel(
                condition = "input.filters == 'Filter Subject'",
                selectInput(
                    inputId  = "filter_subject",
                    label    = "Define Subject Filter",
                    choices  = unique(df_bmi$SUBJECT) |> sort(),
                    multiple = T
                )
            )
        ),

        mainPanel(
            h2("Chosen View"),
            uiOutput("dynamic_view")
        )
    )
)

# Server Operations -------------------------------------------------------

server <- function(input, output) {

    df_filtered <- reactive({
        if (input$filters == "No Filters"){
            df_bmi
        } else if (input$filters == "Filter Subject"){
            df_bmi |> filter(SUBJECT %in% input$filter_subject)
        } else if (input$filters == "Filter Weight"){
            df_bmi |> filter(WEIGHT |> dplyr::between(min(input$filter_weight),
                                                      max(input$filter_weight)))
        }
    })


    output$dynamic_view <- renderUI({
        if (input$choose_view == "Raw"){
            renderPrint({
                df_filtered() |> glimpse()
            })

        } else if (input$choose_view == "Plot"){
            renderPlot({
                df_filtered() |>
                    ggplot(aes(x = WEIGHT, y = HEIGHT)) +
                    geom_point()
            })

        } else if (input$choose_view == "Table"){
            renderTable({
                df_filtered() |> head()
            })
        }
    })

}


# Run Application ---------------------------------------------------------

shinyApp(ui = ui, server = server)
