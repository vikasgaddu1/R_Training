
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

adae <- read_sas("/cloud/project/xx.0 R Markdown and Shiny/adae.sas7bdat") %>%
  select(SUBJID, AEBODSYS, AEHLT, AETERM, AESTDTC)

advs <- read_sas("/cloud/project/xx.0 R Markdown and Shiny/advs.sas7bdat") %>%
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

      ## Import Data ----
      radioButtons(
        inputId  = "select_age_group",
        label    = "Select an Age Group",
        choices  = age_group_list),

      hr(),

      fluidRow(
        column(width = 10, wellPanel(

          ## Select Variables ----
          radioButtons(inputId  = "select_body_system",
                      label    = "Select a Body System",
                      choices  = body_system_list)

        )),

      ),

      ),

    mainPanel(

      fluidRow(
        column(width = 10, wellPanel(

          ## Import Message ----
          htmlOutput("import_message")

        ))
      ),

      hr(),


      ## Variable Summary ----
      tabsetPanel(
        tabPanel("ADSL Data", DT::dataTableOutput("adsl_output")),
        tabPanel("ADSL Plot", plotOutput("adsl_plot")),
        tabPanel("ADAE Data", DT::dataTableOutput("adae_output")),
        tabPanel("ADAE Plot", plotOutput("adae_plot")),
        tabPanel("ADVS Data", DT::dataTableOutput("advs_output")),
        tabPanel("ADVS Plot", plotOutput("advs_plot"))
      )
    )
  )
)

# Server ------------------------------------------------------------------

server <- function(input, output, session) {


  ## Generate available body system lists based on age group chosen ----

    observeEvent(input$select_age_group, {

      t_adae <- adae %>%
        inner_join(adsl, by = c("SUBJID"="SUBJID")) %>%
        filter(AGEGR1 == input$select_age_group) %>%
        mutate(bsystem_list = AEBODSYS)

        u_body_system_list = sort(unique(t_adae$AEBODSYS))

        updateRadioButtons(inputId = "select_body_system",
                           choices = u_body_system_list)
      })


  ## Selection Message ----
  output$import_message <- renderPrint(
    str_glue("You chose the age group <b>{input$select_age_group}</b> and
             the body system <b>{input$select_body_system}<b>.") %>%
      HTML()
  )

  # ADSL Data and Plot Definitions  ------------
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


  ## ADAE Data and Plot Definitions --------
  adae_subset  <- reactive({
    adsl %>%
      inner_join(adae, by=c("SUBJID" = "SUBJID")) %>%
      filter(AGEGR1 == input$select_age_group &
               AEBODSYS == input$select_body_system)  %>%
      select(SUBJID, SITEID, AEBODSYS, AEHLT, AETERM, AESTDTC ) %>%
      DT::datatable(options = list(pageLength = 10))
  })

  adae_ggplot  <- reactive({
    adsl %>%
      inner_join(adae, by=c("SUBJID" = "SUBJID")) %>%
      filter(AGEGR1 == input$select_age_group &
               AEBODSYS == input$select_body_system)  %>%
      select(SUBJID, SITEID, AEBODSYS, AEHLT, AETERM, AESTDTC ) %>%
      group_by(AEHLT) %>%
      summarize(Count = n()) %>%
      ggplot(aes(y=AEHLT, x=Count)) +
      geom_col(fill='orange', show.legend=FALSE)
      })

  ## ADVS Data and Plot Definitions  --------
  advs_subset  <- reactive({
    advs %>%
    inner_join(adsl, by=c("SUBJID" = "SUBJID")) %>%
    inner_join(adae %>%
                 filter(AEBODSYS == input$select_body_system) %>%
                 group_by(SUBJID) %>% slice_head(n=1),
               by=c("SUBJID" = "SUBJID")) %>%
    filter(AGEGR1 == input$select_age_group)  %>%
    select(SUBJID, SITEID, PARAM, AVISIT, BASE, AVAL, CHG ) %>%
    DT::datatable(options = list(pageLength = 10))
  })

  advs_ggplot  <- reactive({
    advs %>%
      inner_join(adsl, by=c("SUBJID" = "SUBJID")) %>%
      inner_join(adae %>%
                   filter(AEBODSYS == input$select_body_system) %>%
                   group_by(SUBJID) %>% slice_head(n=1),
                 by=c("SUBJID" = "SUBJID")) %>%
      filter(AGEGR1 == input$select_age_group)  %>%
      select(SUBJID, SITEID, PARAM, AVISIT, BASE, AVAL, CHG ) %>%
      group_by(PARAM) %>%
      summarize(Mean = mean(CHG)) %>%
      ggplot(aes(y=PARAM, x=Mean)) +
      geom_col(fill='orange', show.legend=FALSE)
  })

 # Define output to output buffer variables.
  output$adsl_output <- DT::renderDataTable(adsl_subset())
  output$adsl_plot <-   renderPlot(adsl_ggplot())
  output$adae_output <- DT::renderDataTable(adae_subset())
  output$adae_plot <-   renderPlot(adae_ggplot())
  output$advs_output <- DT::renderDataTable(advs_subset())
  output$advs_plot <-   renderPlot(advs_ggplot())

}


# Run the Application -----------------------------------------------------

shiny::shinyApp(ui, server)
