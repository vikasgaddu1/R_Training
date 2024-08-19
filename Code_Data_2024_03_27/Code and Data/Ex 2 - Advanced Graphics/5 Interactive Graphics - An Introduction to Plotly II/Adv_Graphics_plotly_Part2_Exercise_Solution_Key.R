# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Interactive Graphics - Solution Key for Plotly Part I Exercises

# Setup -------------------------------------------------------------------

# Load Packages
library(plotly)
library(listviewer)
library(tidyverse)

# Load Data ---------------------------------------------------------------

dm_r <-
  read_rds('data/dm_r.rds')

adae <-
  read_rds('data/adae.rds')

plotdataae <-
  adae %>%
  inner_join(dm_r, by = c("SUBJID" = "SUBJID")) %>%
  select(SUBJID, SITEID, ARM, SEX, AGE,
         AEBODSYS, AEHLT, AETERM, ADURN, AESTDY,
         AESEV, AEREL)

plotbaseae <-
  plotdataae %>%
  plot_ly()

# Exercise 2
plot1 <-
  plotbaseae %>%
  filter(AESEV != "MILD") %>%
  add_markers(x = ~AGE,
              y = ~ADURN,
              name = "Duration vs Age",
              text = ~paste('SUBJID = ', SUBJID, 'AEHLT= ', AEHLT),
              hoverinfo = 'text') %>%
layout(title = list(text = "<b>Study ABC: Adverse Event Duration by Age</b>",
                    x=0.02, y=.98, font=list(size=20)),
       yaxis = list(title = "Duration", dtick = 50),
       xaxis = list(title = "Age", dtick = 10))  %>%
filter(AEREL != 'NOT RELATED') %>%
  add_lines(
    x     = ~AGE,
    y     = ~ADURN,
    color = I("red"),
    name  = 'May be Related',
    line  = list(shape = 'spline'))

plot1

# Exercise 3
plot2 <-
  plotbaseae %>%
  add_histogram(y = ~AESEV,
                color=~SEX,
                stroke = I("black")) %>%
  layout(title = list(text = "<b>Study ABC: Adverse Event Counts by Severity and Sex</b>",
                      x=0.02, y=.98, font=list(size=20)),
         yaxis = list(title = "AE Severity"),
         xaxis = list(title = "Counts", dtick = 5))

plot2

# Exercise 4
subplot(
  # Define Layout
  nrows = 2,

  # Row 1
  plot1,

  # Row 2
  plot2,

  # Size Modifiers (Sum to 1)
  heights = c(0.50, 0.50),    # Row 1 is 20%, Row 2 is 80%
  widths  = c(1),    # Col 1 is 80%, Col 2 is 20%

  shareX = FALSE,
  shareY = FALSE,
  titleX = TRUE,
  titleY = TRUE) %>%
  layout(title = 'Stuff',
         showlegend = TRUE)

