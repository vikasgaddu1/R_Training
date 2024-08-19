
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Interactive Graphics - An Introduction to Plotly I

# Packages & Functions on Display:
# - {plotly 4.9.3}: plot_ly, ggplotly, schema, config, layout,
#                  add_markers, hide_legend, hide_colorbar


# Setup -------------------------------------------------------------------

# Load Packages
library(plotly)
library(listviewer)
library(tidyverse)


# Load Data ---------------------------------------------------------------

df_adslvs <- read_rds('data/adslvs.rds') %>% rename_with(tolower)
df_adslvs %>% glimpse()



# Using ggplot2 -----------------------------------------------------------
# Plotly can convert a static ggplot2 plot into an interactive plot

plot_static <-
  ggplot(df_adslvs,
         aes(x = base_resp, y = aval_resp, fill = sex,
             text = str_glue('Baseline {base_resp}\nFollowup {aval_resp}'))) +
  geom_point(size = 5, shape = 21, color = 'black', alpha = I(0.50)) +
  labs(title = 'Repiratory Values', x = 'Baseline', y = 'Followup',
       fill = 'Patient Sex')

plot_static

plot_static %>% ggplotly()
plot_static %>% ggplotly(tooltip = 'text')   # tooltip: x, y, color, fill, etc.



# Using Plotly ------------------------------------------------------------
# If you want more, let's build a plot using only plotly

plot_ly(df_adslvs)

# Inheritance, Incremental Additions
df_adslvs %>% plot_ly(x = ~base_resp)
df_adslvs %>% plot_ly(x = ~base_resp) %>% add_markers(y = ~aval_resp)
df_adslvs %>% plot_ly(x = ~base_resp) %>% add_markers(y = ~aval_resp) %>% layout(title = "Respiration Values")

plot_base <- df_adslvs %>% plot_ly()
plot_base %>% add_markers(x = ~base_resp, y = ~aval_resp)



# Plotly Tour -------------------------------------------------------------

# Viewer Panel
# - Hover, Hover Controls, Zoom, Crop, Reset

# Plotly
# - A JavaScript library
# - R functions simply pass text into underlying JavaScript functions
# - Investigate JS structure using listviewer::jsonedit()

plot_base %>% listviewer::jsonedit()


# Documentation Note:
# - Plotly documentation is challenging to navigate
# - Use https://plotly.com/r/, plotly::schema(), and Stack Overflow

plotly::schema()


# As Is
# I(): Treats arguments 'as-is', used to pass values to underlying JavaScript
help(I, package = 'base')



# Learning Plotly via Scatter Plot ----------------------------------------
# Aesthetics/Attributes: Size, Symbol, Alpha, Color, Linetype, Stroke, etc.

plot_base %>% add_markers(x = ~base_resp, y = ~aval_resp)


## Fixed Aesthetics ----
plot_base %>%
  add_markers(
    x      = ~base_resp,
    y      = ~aval_resp,
    symbol = I(22),
    size   = I(100),
    alpha  = I(0.20),
    color  = I('red'),
    stroke = I("black"))


## Dynamic Aesthetics ----
# - Discrete
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


# - Continuous
plot_scatter_c <-
  plot_base %>%
  add_markers(
    x       = ~base_resp,
    y       = ~aval_resp,
    color   = ~aval_resp,
    colors  = colorRamp(c('#000004FF', "#781C6DFF", "#ED6925FF", '#FCFFA4FF')),
    stroke  = I('black'),
    alpha   = I(0.75),
    size    = I(100))

plot_scatter_c


## Documentation ----
plotly::schema()


# Available Colors / Symbols
colors()
help(points, package = 'graphics')


# References
# https://plotly.com/r/line-and-scatter/



# Customize Tooltips ------------------------------------------------------
# hoverinfo: text, x, y, z, skip, none, all;
# combine with +
# - none: shows empty popup on hover;
# - skip: disables hover

df_adslvs %>%
  plot_ly() %>%
  add_markers(x = ~base_resp, y = ~aval_resp, color = ~sex,
              stroke = I('black'), size = I(50), alpha = I(0.25))

df_adslvs %>%
  plot_ly() %>%
  add_markers(
    x         = ~base_resp,
    y         = ~aval_resp,
    color     = ~sex,
    text      = ~str_glue('Using HTML Tags: <br><b>Sex</b>: {sex} <br><b>Visit</b>: {avisit}'),
    hoverinfo = 'text+x',
    stroke    = I('black'),
    size      = I(50),
    alpha     = I(0.25)) %>%
  layout(hovermode = 'x unified')


# References
# https://plotly.com/r/hover-text-and-formatting/



# Titles, Axes, Legends ---------------------------------------------------

plot_scatter_c

plot_scatter_c %>%
  layout(title = 'Respiratory Values',
         xaxis = list(title = 'Baseline',
                      showticklabels = TRUE,
                      zeroline = TRUE,
                      range = c(0, 30)),
         yaxis = list(title = 'Followup',
                      showticklabels = FALSE,
                      zeroline = FALSE,
                      range = c(0, 30)))


# Colorbar - Continuous Color Scale
plot_scatter_c %>%
  colorbar(title = list(text = "<b>Continuous <br>Color Scale</b>"),
           len = 1.00)

plot_scatter_c %>% hide_colorbar()


# Legend - Discrete Scales
plot_scatter_d
plot_scatter_d %>% hide_legend()
plot_scatter_d %>%
  layout(legend = list(title = list(text = '<b>Discrete <br>Color Scale</b>')))


# Config
# - Live editing, removing plotly buttons, etc
plot_scatter_c
plot_scatter_c %>% config(displayModeBar = FALSE)
plot_scatter_c %>% config(edits = list(titleText = TRUE))


# References
# https://plotly.com/r/axes/
# https://plotly.com/r/legend/
# https://plotly.com/r/colorscales/



# Documentation -----------------------------------------------------------

plotly::schema()
plotly::schema()$traces$scatter$attributes                 %>% listviewer::jsonedit()
plotly::schema()$layout$layoutAttributes                   %>% listviewer::jsonedit()
plotly::schema()$layout$layoutAttributes$xaxis             %>% listviewer::jsonedit()
plotly::schema()$layout$layoutAttributes$yaxis             %>% listviewer::jsonedit()
plotly::schema()$layout$layoutAttributes$legend            %>% listviewer::jsonedit()
plotly::schema()$traces$scatter$attributes$marker$colorbar %>% listviewer::jsonedit()
plotly::schema()$config                                    %>% listviewer::jsonedit()


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
