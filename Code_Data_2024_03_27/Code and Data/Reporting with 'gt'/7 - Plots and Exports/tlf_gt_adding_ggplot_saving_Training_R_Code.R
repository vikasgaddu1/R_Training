
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2024 Anova Groups All rights reserved

# Course: Clinical Tables with 'gt'
# Lesson: Plots and Exports

# Packages & Functions on Display:
# - {gt 0.10.1}: text_transform, gt_save


# Concepts ----------------------------------------------------------------

# In this lesson, we will be examining methods for adding plots to
# gt table cells. We will also demonstrate saving the gt output to HTML
# and RTF file formats.

# Setup -------------------------------------------------------------------

# Load Packages
library(gt)
library(tidyverse)


# rxadsl is a sample ADaM data frame that is included in the gt package.
# Let's filter it down to just a few variables and rows where TRTA is not NA
# and save a data frame called adsl.
adsl <-
  rx_adsl |>
  select(TRTA, SEX, AGE, BLBMI) |>
  filter(!is.na(TRTA))


# Now let's summarize some data for a gt table.
blbmi <-
  adsl |>
  group_by(TRTA) |>
  summarize(
    min  = min(BLBMI, na.rm = TRUE),
    mean = mean(BLBMI, na.rm = TRUE),
    max  = max(BLBMI, na.rm = TRUE)) |>
  ungroup()


# We can create a function to generate violin plots for BLBMI for each level of
# TRTA. This function will be called from the text_transform() function. Writing
# a function like this is not in the scope of this lesson but included to
# demonstrate adding plots to gt table cells.
plot_violin_trta <- function(my_trta) {
  adsl |>
    filter(TRTA == my_trta) |>
    ggplot(aes(x = BLBMI, y = TRTA)) +
    geom_violin(fill = 'orange') +
    theme_void()
}


# The function works like this
plot_violin_trta(my_trta = "Placebo")



# Adding Plots ------------------------------------------------------------
# Finally, using our summarized data and the violin plot function defined above,
# we can use the text_transform() function to add the violin plots to our gt
# table of summarized BLBMI statistics for each treatment group.

# We're going to add a new column as a placeholder for the plot
blbmi |>
  mutate(dist = TRTA) |>
  gt()


# - Now we use text_transform with locations = cells_body('dist') to identify the
#  column's values we want to replace with a plot
# - In the fn argument, we define a function that is applied to each value in the
#  table using lapply
# - Finally, plot object is converted to an actual image instead of an R plot
#  object using ggplot_image
blbmi |>
  mutate(dist = TRTA) |>
  gt() |>
  text_transform(
    locations = cells_body("dist"),
    fn = function(my_trta){
      lapply(my_trta, plot_violin_trta) |>
        ggplot_image(height = px(50), aspect_ratio = 3)
    })



# Exporting Tables --------------------------------------------------------

# Let's dress up the table we just made with headers and spanners
blbmi_withplot_output <-
  blbmi |>
  mutate(dist = TRTA) |>
  gt() |>
  tab_header(title = "Baseline BMI Statistics by Actual Treatment") |>
  cols_label(dist = "Distribution") |>
  tab_spanner(
    label   = "BMI Statistics",
    columns = -TRTA) |>
  text_transform(
    locations = cells_body(columns = 'dist'),
    fn = function(column) {
      lapply(column, plot_violin_trta) |>
        ggplot_image(height = px(50), aspect_ratio = 3)
    })

blbmi_withplot_output

# We use gtsave to export the table to various output formats, including HTML,
# PDF, and RTF Saving your gt output to HTML and RTF
gtsave(blbmi_withplot_output, 'blbmi_output.html')


# RTF output is a bit more limited, so we'll remove the plot from the table
blbmi_tableonly_output <-
  blbmi |>
  gt() |>
  tab_header(title = "Baseline BMI Statistics by Actual Treatment") |>
  cols_label(
    min  = "Min",
    mean = "Mean",
    max  = "Max") |>
  tab_spanner(
    label   = "BMI Statistics",
    columns = -TRTA)


blbmi_tableonly_output

gtsave(blbmi_tableonly_output, 'blbmi_output.rtf')



# Documentation -----------------------------------------------------------

# Help Pages
help("gtsave",          "gt")
help("text_transform",  "gt")


# Website References
# https://gt.rstudio.com/articles/gt.html
# -------------------------------------------------------------------------
