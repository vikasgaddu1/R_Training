# Anova Accel2R - Clinical R Training -----------------------------------
# © 2023 Anova Groups All rights reserved

# Title: Shiny Performance - Caching Results

# Packages & Functions on Display:
# - {shiny 1.7.3}: bindCache


# Concepts ----------------------------------------------------------------

# The bindCache function will store hashed results to disk and load them when
# the same combination of dependencies are selected by the user.
#
# By default the cache is shared with all users of the running application, this
# means that all users can benefit from improved load times after one user has
# clicked through the app.
# - This behavior can be modified with the 'cache' argument in bindCache
#
# See the following online documentation for more information on finer control
# over cache scoping rules, and tips on how to use bindCache when deploying a
# Shiny app on a server like `Posit Connect` or `shinyapps.io`

# Documentation:
# https://shiny.rstudio.com/articles/caching.html

# Setup -------------------------------------------------------------------

library(shiny)
library(ggplot2)


# User Interface ----------------------------------------------------------

ui <- fluidPage(

    titlePanel("Caching Results"),

    sidebarLayout(
        sidebarPanel(

            varSelectInput(
                inputId  = "select",
                label    = "Select Variables",
                multiple = T,
                selected = colnames(diamonds),
                data     = diamonds
            ),

            actionButton(
                inputId = "button",
                label   = "Render Plot"
            ),
            actionButton(
                inputId = "reset",
                label   = "Clear Results"
            )

        ),

        mainPanel(
            plotOutput("out_plot")
        )
    )
)

# Server Operations -------------------------------------------------------

server <- function(input, output) {

    my_vars <- reactive({
        as.character(input$select)
    })

    observeEvent(input$button,{
        output$out_plot <- renderPlot({
            diamonds[my_vars()] |> plot()
        }) |> bindCache(my_vars())
    })

    observeEvent(input$reset, {
        output$out_plot <- NULL
    })

}


# Run Application ---------------------------------------------------------

shinyApp(ui = ui, server = server)
