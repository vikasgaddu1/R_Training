# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Interactive Graphics - Solution Key for Plotly Part I Exercises

# Setup -------------------------------------------------------------------

# Load Packages
library(plotly)
library(listviewer)
library(tidyverse)

# Load Data ---------------------------------------------------------------
plotdata <- read_rds('data/adslvs.rds') %>% rename_with(tolower)
plotdata %>% glimpse()

# summarize data
pd_freq <-
  plotdata %>%
  group_by(avisit) %>%
  summarise(n_pulse = sum(!is.na(aval_pulse)),
            mean_pulse = mean(aval_pulse, na.rm = TRUE))

# Produce a static plot
plot_static <-
  ggplot(pd_freq,
         aes(
           x = avisit,
           y = mean_pulse,
           text = str_glue('Visit= {avisit}: Mean Pulse= {mean_pulse}')
         )) +
  geom_col(color = 'red', fill = 'black') +
  labs(title = "Study ABC: Average Pulse by Visit",
       caption = "Note: from Study ABC",
       x = "Visit",
       y = "Average Pulse")


# send static plot to plots tab
plot_static

# use ggplotly to convert to a non-static plot
plot_nonstatic1 <-
  plot_static %>%
  ggplotly(tooltip = 'text')   # tooltip: x, y, color, fill, etc.

# send dynamic plot to viewer tab
plot_nonstatic1


# exercise 2
pd_freq %>%
  plot_ly(x = ~avisit,
          y = ~mean_pulse,
          text = ~paste('Visit= ', avisit, 'Mean Pulse= ', mean_pulse),
          hoverinfo = 'text') %>%
  add_bars(marker = list(color = 'black',
           line = list(color = 'red', width = 1.5))) %>%
  layout(title = list(text = "<b>Study ABC: Average Pulse by Visit</b>",
                      x=0.02, y=.98, font=list(size=20)),
         yaxis = list(title = "Average Pulse", dtick=20),
         xaxis = list(title = "Visit"))


# exercise 3a
plotdata %>%
  plot_ly(x = ~arm, y = ~sex,
          text = ~paste('Sex = ', sex, 'Treatment Arm = ', arm),
          hoverinfo = 'text') %>%
  layout(title = list(text = "<b>Study ABC: Frequency Counts by Sex and Arm</b>",
                    x=0.02, y=.98, font=list(size=20)),
       yaxis = list(title = "Sex", dtick=20),
       xaxis = list(title = "Treatment Arm"))


# exercise 3b
plotdata %>%
  plot_ly(x = ~aval_pulse,
          text = ~paste('Frequency = ', aval_pulse),
          hoverinfo = 'text') %>%
  layout(title = list(text = "<b>Study ABC: Histogram of Pulse</b>",
                      x=0.02, y=.98, font=list(size=20)),
         yaxis = list(title = "Frequency"),
         xaxis = list(title = "Pulse"))


# exercise 3c
plotdata %>%
  plot_ly(x = ~aval_pulse, y = ~age,
          text = ~paste('Pulse = ', aval_pulse, 'Age = ', age),
          hoverinfo = 'text') %>%
  layout(title = list(text = "<b>Study ABC: Scatterplot of Pulse by Age</b>",
                      x=0.02, y=.98, font=list(size=20)),
         yaxis = list(title = "Pulse", dtick=20),
         xaxis = list(title = "Age"))



