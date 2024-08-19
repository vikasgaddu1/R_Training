# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Interactive Graphics - An Introduction to Plotly II

# Packages & Functions on Display:
# - {plotly 4.9.3}: plot_ly, schema, group_by, filter, subplot, layout,
#                  add_markers, add_lines, add_histogram, add_bars, add_boxplot


# Setup -------------------------------------------------------------------

# Load Packages
library(plotly)
library(listviewer)
library(tidyverse)


# Load Data ---------------------------------------------------------------

df_adslvs <- read_rds('data/adslvs.rds') %>% rename_with(tolower)
df_adslvs %>% glimpse()


# Summary Data
df_summary_age <-
  df_adslvs %>%
  group_by(agegr1) %>%
  summarise(
    n    = n(),
    mean = mean(aval_resp),
    std  = sd(aval_resp)) %>%
  print()


df_summary_agesex <-
  df_adslvs %>%
  group_by(agegr1, sex) %>%
  summarise(
    n    = n(),
    mean = mean(aval_resp),
    std  = sd(aval_resp)) %>%
  print()


# Base Plot
plot_base <- df_adslvs %>% plot_ly()



# Line Charts -------------------------------------------------------------
# Linetype / Dash: solid, dot, dash, longdash, dashdot, longdashdot
# Shape: linear, spline, vh, hv, vhv, hvh

# Basic Line Chart
plot_base %>%
  filter(subjid == '049') %>%
  add_lines(x = ~avisitn, y = ~aval_temp, linetype = I("solid"))


# Grouped Line Chart
plot_base %>%
  filter(subjid %in% c('049', '050', '051')) %>%
  group_by(subjid) %>%
  add_lines(
    x = ~avisitn,
    y = ~aval_temp)


# Define Linetypes
plot_base %>%
  filter(subjid %in% c('049', '050', '051')) %>%
  add_lines(
    x         = ~avisitn,
    y         = ~aval_temp,
    linetype  = ~subjid,
    linetypes = c('049' = 'dash', '050' = 'dot', '051' = 'solid'))


# Define Line Shape
plot_base %>%
  filter(subjid %in% c('049', '050', '051')) %>%
  group_by(subjid) %>%
  add_lines(
    x    = ~avisitn,
    y    = ~aval_temp,
    line = list(shape = 'spline'))


# Use Case: Highlights
plot_base %>%
  group_by(subjid) %>%
  add_lines(
    x     = ~avisitn,
    y     = ~aval_temp,
    alpha = I(0.10),
    name  = 'Overall',
    line  = list(shape = 'linear')) %>%
  filter(subjid == '049') %>%
  add_lines(
    x     = ~avisitn,
    y     = ~aval_temp,
    color = I("red"),
    name  = 'Patient 049',
    line  = list(shape = 'spline'))


# References
# https://plotly.com/r/line-charts/



# Histograms --------------------------------------------------------------
# - Plotly histograms use RAW data to create typical histograms
# - Along with creating categorical bar charts

# Histogram - Continuous
plot_base %>%
  add_histogram(
    x      = ~aval_resp,
    color  = I('gray'),
    stroke = I('black'))


# Histogram - Continuous by Category
plot_base %>%
  add_histogram(
    x      = ~age,
    color  = ~sex,
    stroke = I('black'))


# Barchart - Two Categorical Variables
plot_base %>%
  add_histogram(
    x      = ~agegr1,
    color  = ~sex,
    stroke = I('black'))


# Stacked Bar Chart - With Raw Data
plot_base %>%
  add_histogram(x = ~agegr1, color = ~sex, stroke = I('black')) %>%
  layout(barmode = 'stack')


# References
# https://plotly.com/r/histograms/



# Bar Charts --------------------------------------------------------------
# Plotly bar charts only work with SUMMARY data counts

df_summary_age
df_summary_agesex

# One Way Bar Chart
df_summary_age %>%
  plot_ly() %>%
  add_bars(
    x = ~agegr1,
    y = ~n)

# Two Way Bar Chart
df_summary_agesex %>%
  plot_ly() %>%
  add_bars(
    x      = ~agegr1,
    y      = ~n,
    color  = ~sex,
    stroke = I('black')) %>%
  layout(barmode = 'group')

# Stacked Bar Chart
df_summary_agesex %>%
  plot_ly() %>%
  add_bars(
    x      = ~agegr1,
    y      = ~n,
    color  = ~sex,
    stroke = I('black')) %>%
  layout(barmode = 'stack')


# References
# https://plotly.com/r/bar-charts/
# https://plotly.com/r/horizontal-bar-charts/


# Box Plots ---------------------------------------------------------------
# Gives warning message for side-by-side boxplot, but it works

plot_base %>%
  add_boxplot(
    x      = ~avisit,
    y      = ~aval_resp,
    color  = ~sex,
    stroke = I('black')) %>%
  layout(boxmode = 'group')


# References
# https://plotly.com/r/box-plots/



# 3D Plots ----------------------------------------------------------------
# Click and drag to adjust the perspective of the plot
# Use mouse wheel to zoom in and out

plot_base %>%
  add_markers(
    x      = ~base_resp,
    y      = ~base_temp,
    z      = ~base_pulse,
    color  = ~sex,
    symbol = I(15),
    stroke = I('black'),
    alpha  = I(0.50))


# References
# https://plotly.com/r/3d-charts/



# Combining Plots ---------------------------------------------------------

# Scatter Plot
df_adslvs %>%
  plot_ly(x = ~agegr1) %>%
  add_markers(y = ~aval_resp, symbol = I(15), color = I('black'), alpha = I(0.10))


# Error Bars
plot_ly() %>%
  add_markers(
    data    = df_summary_age,
    x       = ~agegr1,
    y       = ~mean,
    error_y = ~list(value = std),
    color   = I('black'))


# Average Line
plot_ly() %>%
  add_lines(
    data  = df_summary_age,
    y     = ~mean,
    x     = ~agegr1,
    size  = I(5),
    color = I('red'),
    line  = list(shape = 'spline'))


# Putting it All Together
df_adslvs %>%
  plot_ly(
    x       = ~agegr1) %>%
  add_markers(
    y       = ~aval_resp,
    symbol  = I(15),
    alpha   = I(0.10),
    color   = I('black'),
    name    = 'Scatter') %>%
  add_markers(
    data    = df_summary_age,
    y       = ~mean,
    color   = I('black'),
    error_y = ~list(value = std),
    name    = 'Std Error') %>%
  add_lines(
    data    = df_summary_age,
    y       = ~mean,
    size    = I(5),
    color   = I('red'),
    line    = list(shape = 'spline'),
    name    = 'Average Line')



# Combining with Subplot --------------------------------------------------

# Desired Grid Layout
# _______________
# | Hist  | Blank |
# |_______|_______|
# | Point | Hist  |
# |_______|_______|


subplot(
  # Define Layout
  nrows = 2,

  # Row 1
  plot_base %>% add_histogram(x = ~base_resp, name = 'Baseline Histogram'),
  plotly_empty(),

  # Row 2
  plot_base %>% add_markers(x = ~base_resp, y = ~aval_resp, name = 'Scatter'),
  plot_base %>% add_histogram(y = ~aval_resp, name = 'Followup Histogram'),

  # Size Modifiers (Sum to 1)
  heights = c(0.20, 0.80),    # Row 1 is 20%, Row 2 is 80%
  widths  = c(0.80, 0.20),    # Col 1 is 80%, Col 2 is 20%

  shareX = TRUE,
  shareY = TRUE,
  titleX = TRUE,
  titleY = TRUE) %>%
  layout(title = 'Respiration Values',
         showlegend = TRUE)



# Annotations -------------------------------------------------------------

plot_scatter_d <-
  plot_base %>%
  add_markers(
    x       = ~base_resp,
    y       = ~aval_resp,
    color   = ~sex,
    symbol  = ~sex,
    colors  = c('Male' = 'black', 'Female' = 'red'),
    symbols = c('Male' = 14,      'Female' = 20),
    alpha   = I(0.75),
    size    = I(100))

plot_scatter_d

plot_annotation <-
  df_adslvs %>%
  group_by(sex) %>%
  slice_max(base_resp) %>%
  slice_min(aval_resp) %>%
  slice_sample(n = 1) %>%
  select(sex, age, base_resp, aval_resp) %>%
  print()

plot_scatter_d %>%
  layout(
    annotations =
      list(x    = plot_annotation$base_resp,
           y    = plot_annotation$aval_resp,
           text = plot_annotation$sex))


# References
# https://plotly.com/r/text-and-annotations/



# Adding Reference Lines --------------------------------------------------
# Linetype / Dash: solid, dot, dash, longdash, dashdot, longdashdot

# On Categorical Axis
df_summary_age %>%
  plot_ly(x = ~mean, y = ~agegr1) %>%
  add_markers(
    error_x = ~list(value = std),
    color   = I("black"),
    size    = I(20)) %>%
  layout(
    shapes = list(type = 'line',
                  line = list(color = 'red', width = 5, dash = 'dot'),
                  x0 = mean(df_summary_age$mean),
                  x1 = mean(df_summary_age$mean),
                  y0 = -1,
                  y1 = length(df_summary_age$mean)))


# On Continuous Axis
plot_base %>%
  add_markers(
    x = ~age, y = ~base_resp,
    color = I('black'),
    size  = I(20),
    alpha = I(0.25)) %>%
  layout(
    shapes = list(type = 'line',
                  line = list(color = 'red', width = 5, dash = 'longdash'),
                  x0 = mean(df_adslvs$age),
                  x1 = mean(df_adslvs$age),
                  y0 = min(df_adslvs$base_resp),
                  y1 = max(df_adslvs$base_resp)))



# Documentation -----------------------------------------------------------

schema()

schema()$traces$scatter$attributes$line                       %>% listviewer::jsonedit()
schema()$traces$histogram                                     %>% listviewer::jsonedit()
schema()$traces$box                                           %>% listviewer::jsonedit()

schema()$layout$layoutAttributes$annotations$items$annotation %>% listviewer::jsonedit()
schema()$layout$layoutAttributes$shapes$items$shape           %>% listviewer::jsonedit()


# Available Colors / Symbols
colors()
help(points, package = 'graphics')



# References --------------------------------------------------------------

# Website References
# https://plotly.com/r/
# https://plotly.com/r/basic-charts/
# https://plotly.com/r/plotly-fundamentals/

# Free Online Book
# https://plotly-r.com/


# Other Interactive Plotting Packages
# - Leaflet, Dygraphs, Highchartr, RGL

# -------------------------------------------------------------------------
