# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Solution Key

# Setup -------------------------------------------------------------------

# Load Packages
# Exercise Step 3
library(tidyverse)
library(haven)
library(janitor)

# Exercise Step 5
cm <-
  read_sas("data/abc_crf_cm.sas7bdat") %>%
  select(SUBJECT, CMTRT, CMINDC) %>%
  filter(str_detect(CMINDC, "ACHE")) %>%
  mutate(
    CMTRT_F = factor(CMTRT, ordered = TRUE),
    CMINDC_F = factor(CMINDC, ordered = TRUE)
  )

# Exercise Step 6
base_plot <- function(data, y_fill) {
  library(rlang)

  ggplot(data, aes(y = {
    {
      y_fill
    }
  }, fill = {
    {
      y_fill
    }
  })) +
    geom_bar() +
    scale_y_discrete(drop = FALSE) +
    scale_fill_viridis_d(end = 0.75, drop = FALSE) +
    guides(fill = 'none') +
    labs(y = NULL, x = NULL)
}


# Exercise Step 7.a
tabyl(fct_infreq(cm$CMTRT))
base_plot(cm, y_fill = fct_infreq(CMTRT) %>%
            fct_rev())

# Exercise Step 7.b
tabyl(fct_inorder(cm$CMTRT))
base_plot(cm, y_fill = fct_inorder(CMTRT) %>%
            fct_rev())

# Exercise Step 7.c
tabyl(fct_lump_min(cm$CMTRT, min = 10))
base_plot(cm, fct_lump_min(CMTRT, min = 10) %>% fct_rev())

# Exercise Step 7.d
tabyl(fct_lump_prop(cm$CMTRT, prop = .1))
base_plot(cm, fct_lump_prop(CMTRT, prop = .1) %>% fct_rev())

# Exercise Step 7.e
tabyl(fct_other(cm$CMTRT, keep = c("TYLENOL", "IBUPROFEN")))
base_plot(cm, fct_other(CMTRT, keep = c("TYLENOL", "IBUPROFEN")) %>%
            fct_rev())

