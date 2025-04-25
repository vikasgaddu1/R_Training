
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2024 Anova Groups All rights reserved

# Course: Clinical Tables with 'gt'
# Lesson: Table Styles

# Packages & Functions on Display:
# - {gt 0.10.0}: gt_preview, gt, opt_interactive


# Setup -------------------------------------------------------------------
# Load Packages

# Exercise step 1
library(tidyverse)
library(gt)
library(haven)
library(ggplot2)

advs <-
  read_sas('_data/abc_adam_advs.sas7bdat') |>
  filter(PARAMCD == "PULSE" & TRTA != "") |>
  select(SUBJID, TRTA, ADY, AVAL, CHG) |>
  rename(Subject = SUBJID,
         Treatment = TRTA,
         StudyDay = ADY,
         Pulse = AVAL,
         PulseCFB = CHG)


# Now let's summarize some data for a gt table.
advs_summ <-
  advs |>
  group_by(Treatment, StudyDay) |>
  summarize(
    min  = min(Pulse, na.rm = TRUE),
    mean = mean(Pulse, na.rm = TRUE),
    max  = max(Pulse, na.rm = TRUE)) |>
  ungroup()


advs_summ2 <-
  advs |>
  group_by(Treatment) |>
  summarize(
    min  = min(Pulse, na.rm = TRUE),
    mean = mean(Pulse, na.rm = TRUE),
    max  = max(Pulse, na.rm = TRUE)) |>
  ungroup()

plot_line_trta <- function(my_trta) {
  advs_summ |>
    filter(Treatment == my_trta) |>
    ggplot(aes(x = StudyDay, y = mean)) +
    geom_line(aes(color = "orange"), size = 1) +
    theme_minimal()
}

print(advs_summ, n = 15)
# plot_line_trta(my_trta = "ARM A")


# Exercise step 2
advs_summ_w_plots <-
  advs_summ2 |>
  mutate(Plot = Treatment) |>
  gt() |>
  cols_label(Plot = md("Mean Pulse <br> by Study Day")) |>
  tab_spanner(label = "Plot Summary Stats", columns = c(min, mean, max)) |>
  text_transform(
    locations = cells_body("Plot"),
    fn = function(my_trta){
      lapply(my_trta, plot_line_trta) |>
        ggplot_image(height = px(50), aspect_ratio = 3)
    })

advs_summ_w_plots

# Exercise step 3
# Part a
gtsave(advs_summ_w_plots, 'advs_summ_w_plots.html')

# Exercise step 3
# Part b
advs_summ_wo_plots <-
  advs_summ2 |>
  gt() |>
  tab_spanner(label = "Summary Stats", columns = c(min, mean, max))

advs_summ_wo_plots

gtsave(advs_summ_w_plots, 'advs_summ_wo_plots.rtf')

# Exercise step 3
# Part c
library(webshot)
gtsave(advs_summ_w_plots, 'advs_summ_w_plots.pdf')

