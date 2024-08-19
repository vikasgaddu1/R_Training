# Anova Accel2R - Clinical R Training -----------------------------------
# © 2023 Anova Groups All rights reserved

# Title: Debugging for the End User

# Packages & Functions on Display:
# - {shiny 1.7.3}: validate, need


# Concepts ----------------------------------------------------------------

# - Crafting validation errors to help end users correct issues during app use
# - These are not necessarily errors for the R programmers creating the application
# - Sanitizing error messages for security purposes

# Note:
# It is recommended to create validation steps that "fail fast" and in a useful
# way. This means you should structure your app in such a way as to validate the
# input before any heavy processing is done. One way to do this is to Test
# reactive inputs individually before they are used elsewhere

# Online Documentation:
# https://shiny.rstudio.com/articles/validation.html
# https://shiny.rstudio.com/articles/sanitize-errors.html

# https://mastering-shiny.org/
# https://shiny.rstudio.com/articles/

# Setup -------------------------------------------------------------------

options(shiny.sanitize.errors = T)

library(shiny)
library(tidyverse)

# User Interface ----------------------------------------------------------

ui <- fluidPage(

    tags$head(tags$style(HTML(".shiny-output-error-validation {color: red;}"))),

    titlePanel("Debugging for the End User"),
    sidebarLayout(
        sidebarPanel(
            varSelectInput(
                inputId = "variable_select",
                label   = "Select a variable",
                data    = diamonds),
            radioButtons(
                inputId = "output_type",
                label   = "Select type of output",
                choices = c("Histogram", "Table", "Text"))),
        mainPanel(
            uiOutput("selection")
        )
    )
)

# Server Operations -------------------------------------------------------

server <- function(input, output) {

    output$selection <- renderUI({

        my_variable <- input$variable_select
        my_vector   <- diamonds[[my_variable]]

        validate(
            need(my_vector |> is.numeric(),
                 message = "This application is meant for numeric variables only!"),

        )

        if (input$output_type == "Histogram"){
            renderPlot({
                diamonds |>
                    ggplot(aes(x = .data[[my_variable]])) +
                    geom_histogram() +
                    labs(x = paste("Histogram of", my_variable))
            })
        } else if (input$output_type == "Table"){
            renderTable({
                diamonds |>
                    summarize(
                        mean   = mean(.data[[my_variable]], na.rm = T),
                        median = median(.data[[my_variable]], na.rm = T),
                        sd     = sd(.data[[my_variable]], na.rm = T),
                        tvalue = t.test(.data[[my_variable]])$statistic,
                        pvalue = t.test(.data[[my_variable]])$p.value)
            })
        } else if (input$output_type == "Text"){
            renderText({
                str_glue("The variable {v} is {t} with a quartiles of [{q}].",
                         v = input$variable_select,
                         t = my_vector |> class() |> str_flatten(collapse = " and "),
                         q = my_vector |> quantile() |> str_flatten(collapse = ", "))
            })
        }
    })

}


# Run Application ---------------------------------------------------------

shinyApp(ui = ui, server = server)
