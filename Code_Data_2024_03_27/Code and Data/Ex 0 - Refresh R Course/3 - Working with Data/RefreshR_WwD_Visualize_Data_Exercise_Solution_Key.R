# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

library(tidyverse)
library(scales)

# Exercise Step 2
# Code to build tibble data frames
adsl <-
  read_rds("data/adslvs.rds") %>% 
  filter(avisitn == 8) %>% 
  select(-avisit, -avisitn)

adsl_summary <-
  adsl %>%
  group_by(arm) %>%
  summarise(
    median = median(age, na.rm = T))


# Exercise Step 3
scatter1 <-
  adsl %>% 
  ggplot(aes(x = base_temp, y = base_pulse)) +
  geom_point(size = 3,
    aes(shape = sex,
        color = sex)) +
  geom_hline(yintercept = 70) +
  geom_vline(xintercept = 37) +
  labs(
    title = "Vital Signs Scatterplot",
    subtitle = "Base Pulse by Base Temperature (C)",
    y = "Base Pulse",
    x = "Base Temperature (C)") +
  theme(
    plot.background = element_rect(fill = "lightyellow"),
    panel.background = element_rect(fill = "lightblue"))


# View the plot
scatter1

# save the plot
ggsave("scatter1.png", scatter1)


# Exercise Step 4
barchart1 <-
  adsl_summary %>%
  ggplot(aes(x = arm, y = median, label = str_glue("Median = {median}"))) +
  geom_col(fill = "red") +
  geom_label(nudge_y = -2) +
  labs(
    title = "Median Age by Treatment ARM",
    y = "Median Age",
    x = "Treatment ARM") +
  theme(
    plot.background = element_rect(fill = "lightyellow"),
    panel.background = element_rect(fill = "lightblue"))
barchart1

# save the plot
ggsave("barchart1.png", barchart1)
