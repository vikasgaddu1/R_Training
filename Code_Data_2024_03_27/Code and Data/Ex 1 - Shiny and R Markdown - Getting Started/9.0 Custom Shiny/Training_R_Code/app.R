
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Customizing Shiny with CSS and Bootstrap Themes

# Packages & Functions on Display:
# - {shiny    1.6.0}: icon, HTML
# - {bslib    0.2.4}: bs_theme, bs_themer
# - {thematic 0.1.2}: thematic_shiny


# Setup -------------------------------------------------------------------

# Load Packages
library(bslib)
library(thematic)
library(shiny)
library(tidyverse)


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
    titlePanel("Customizing Shiny"),

    sidebarLayout(

        sidebarPanel(

            actionButton("button_id", "Default Shiny Button"),

            # Use 'icon' argument with icon() to add symbols
            # - See help(icon) for available symbols
            br(),
            actionButton("button_id", "Add an Icon", 
                         icon = shiny::icon("arrow-right")),


            # Use 'class' argument to use pre-existing bootstrap buttons
            # - https://www.w3schools.com/bootstrap/bootstrap_buttons.asp
            br(),
            actionButton("button_id", "Success Theme", 
                         class = "btn-success"),

            # Use 'style' argument to add custom CSS to button
            # - https://www.w3schools.com/css/
            br(),
            actionButton(
                "button_id", 
                "Customize the CSS",
                style = "color: #000; background-color: orange; border-color: black"),


            # Use tags()$style to customize CSS for other UI elements
            hr(),
            shiny::tags$style(
                HTML(".selectize-input {
                        height:        100px;
                        width:         100px;
                        font-size:      24pt;
                        color:        orange;
                        border-color:  black;
                      }")),
            selectInput("selection_id", "Select Input", c("A", "B", "C")),


            # But HTML and CSS tags can be challenging to use
            # - For example, adjusting the color of sliderInput is not as straightforward
            br(),
            sliderInput("slide_id", "Slider Input", min = 1, max = 10, value = 5)

        ),

        mainPanel(
            tabsetPanel(
                tabPanel("1st Panel", plotOutput("my_ggplot")),
                tabPanel("2nd Panel", wellPanel()),
                tabPanel("3rd Panel", wellPanel())
            )
        )
    ),

    # Custom Themes ----
    # - We can use 'bslib' to make adjustments to the Shiny Bootstrap template itself
    # - We can use existing themes from https://bootswatch.com/
    # theme = bslib::bs_theme(bootswatch = "darkly")
    # theme = bslib::bs_theme(bootswatch = "minty")


    # Interactive Themes ----
    # - Interactively Define UI Theme
    # - Note: See console when choosing themes, to copy and paste custom bs_theme()
    theme = bslib::bs_theme()
    
)



# Server ------------------------------------------------------------------

server <- function(input, output, session) {

    output$my_ggplot <- renderPlot(
        mtcars %>%
            ggplot(aes(x = mpg, y = disp)) +
            geom_point() +
            geom_smooth()
    )

    # Interactive Themes ----
    thematic::thematic_shiny()     # This includes ggplot2 in the theme updates
    bslib::bs_themer()             # This is the engine behind interactive themes

}



# Run App -----------------------------------------------------------------

shiny::shinyApp(ui, server)


# Documentation -----------------------------------------------------------

# Shiny Icons
# help(icon, package = "shiny")

# Importing a CSS File
# https://shiny.rstudio.com/articles/css.html


# Bootstrap Buttons
# https://www.w3schools.com/bootstrap/bootstrap_buttons.asp

# Bootstrap Themes
# https://bootswatch.com/

# -------------------------------------------------------------------------
