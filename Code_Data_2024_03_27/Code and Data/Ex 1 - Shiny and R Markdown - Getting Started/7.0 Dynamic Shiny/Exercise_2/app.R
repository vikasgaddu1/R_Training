
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Setup -------------------------------------------------------------------

# Load Packages
library(fs)
library(shiny)
library(tidyverse)
library(haven)

# Data Prep
adsl <- read_sas("../data/adsl.sas7bdat") %>%
  select(SITEID, SUBJID, AGEGR1, SEX) %>%
  mutate(AGEGR1 = factor(AGEGR1,
                         levels = c("18-29 years", "30-39 years", "40-49 years",
                                    "50-65 years", ">65 years"),
                         ordered = TRUE))

adae <- read_sas("adae.sas7bdat") %>%
  select(SUBJID, AEBODSYS, AEHLT, AETERM, AESTDTC)

advs <- read_sas("advs.sas7bdat") %>%
  select(SUBJID, PARAM, AVISIT, AVISITN, BASE, AVAL, CHG) %>%
  filter(AVISITN == 8)

age_group_list=sort(unique(adsl$AGEGR1))
body_system_list=sort(unique(adae$AEBODSYS))

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
  titlePanel("Data Explorer"),

  sidebarLayout(
    sidebarPanel(width=4,

                 ## Radio button for age group ----



                 ## Radio button for body system ----

    ),

    mainPanel(

      fluidRow(
        column(width = 10, wellPanel(

          ## Age group and body system selection message ----
          htmlOutput("import_message")

        ))
      ),

      hr(),


      ## Define tabPanels ----
      tabsetPanel(
      )
    )
  )
)

# Server ------------------------------------------------------------------

server <- function(input, output, session) {

  observeEvent(input$select_age_group, {

  ## Generate available body system lists based on age group chosen ----

})

  observeEvent(input$select_age_group, {

 # When someone changes the age group, update the radio button for body system.

  })


  ## Selection Message ----
  output$import_message <- renderPrint(
  # put message to display here regarding the selections made by the user.
      HTML()
  )

  # ADSL Data and Plot Definitions. ------------
  adsl_subset  <- reactive({
    adsl %>%
      inner_join(adae, by=c("SUBJID" = "SUBJID")) %>%
      filter(AGEGR1 == input$select_age_group &
               AEBODSYS == input$select_body_system)  %>%
      select(SUBJID, SITEID, AGEGR1, SEX ) %>%
      group_by(SUBJID) %>%
      slice_head(n=1) %>%
      DT::datatable(options = list(pageLength = 10))
  })

  adsl_ggplot  <- reactive({
    adsl %>%
      inner_join(adae, by=c("SUBJID" = "SUBJID")) %>%
      filter(AGEGR1 == input$select_age_group &
               AEBODSYS == input$select_body_system)  %>%
      select(SUBJID, SITEID, AGEGR1, SEX ) %>%
      group_by(SUBJID) %>%
      slice_head(n=1) %>%
      group_by(SEX) %>%
      summarize(Count = n()) %>%
      ggplot(aes(y=SEX, x=Count)) +
      geom_col(fill='orange', show.legend=FALSE)
  })

## ADAE Data and Plot Definitions go here --------

## ADVS Data and Plot Definitions go here --------

## Define output to output buffer variables here --------

}


# Run the Application -----------------------------------------------------

shiny::shinyApp(ui, server)
