# Anova Accel2R - Clinical R Training -----------------------------------
# © 2024 Anova Groups All rights reserved

# Course: Clinical Tables with 'gt'
# Lesson: Table Style

# Packages & Functions on Display:
# - {gt 0.10.1}: tab_style, cells_title, cells_footnotes, cell_text,
#               cells_body, cell_borders, cells_fill, data_color


# Setup -------------------------------------------------------------------

# Load the packages necessary for this lesson.
library(gt)
library(tidyverse)

setwd("/cloud/project/Code_Data_2024_03_27/Code and Data/Reporting with 'gt'")

# For this lesson, we will use a data frame from the _data/ directory. Let's
# create an age bin variable and filter it down to just a few variables. We'll
# also create a datetime variable

adsl <-
  readRDS('_data/ADSL.rds') |>
  filter(ARM == "ARM A" & AGE > 0) |>
  select(SUBJID, ARM, AGE, TRTSDT, TRTEDT)



# Table Styles ------------------------------------------------------------

# Starting Point
adsl |>
  gt() |>
  tab_header(title = "ADSL Listing") |>
  tab_footnote(footnote = "Confidential")


# Modify table styles with 'tab_style', and use 'cell_borders' to target the
# borders of the table cells
adsl |>
  gt() |>
  tab_header(title = "ADSL Listing") |>
  tab_footnote(footnote = "Confidential") |>
  tab_style(
    style = cell_borders(
      sides = "all",
      color = "red"),
    locations = cells_body())


# Here we're adding blue borders around the title box with cells_title
adsl |>
  gt() |>
  tab_header(title = "ADSL Listing") |>
  tab_footnote(footnote = "Confidential") |>
  tab_style(
    style = cell_borders(
      sides = "all",
      color = "red"),
    locations = cells_body()) |>
  tab_style(
    style = cell_borders(
      weight = 2,
      sides  = "all",
      color  = "blue"),
    locations = cells_title())

# save output in html file
adsl |>
  gt() |>
  tab_header(title = "ADSL Listing") |>
  tab_footnote(footnote = "Confidential") |>
  tab_style(
    style = cell_borders(
      sides = "all",
      color = "red"),
    locations = cells_body()) |>
  tab_style(
    style = cell_borders(
      weight = 2,
      sides  = "all",
      color  = "blue"),
    locations = cells_title()) |>
  gtsave("adsl_table.html")

# Now we're adding color to the footer box using a list to hold multiple style
# definitions. We use cell_fill to modify the background color of the footer
# box, and we use cell_text to modify the text of the footer box
adsl |>
  gt() |>
  tab_header(title = "ADSL Listing") |>
  tab_footnote(footnote = "Confidential") |>
  tab_style(
    style = cell_borders(
      sides = "all",
      color = "red"),
    locations = cells_body()) |>
  tab_style(
    style = cell_borders(
      weight = 2,
      sides  = "all",
      color  = "blue"),
    locations = cells_title()) |>
  tab_style(
    style = list(
      cell_fill(color = "gray35"),
      cell_text(color = "white")),
    locations = cells_footnotes())



# Conditional Styles ------------------------------------------------------
# We can also add styles to cells based on values based on a column.

# Here we apply color and weight styles where AGE >= 65
adsl |>
  gt() |>
  tab_header(title = "ADSL Listing") |>
  tab_footnote(footnote = "Confidential") |>
  tab_style(
    style = list(
      cell_fill(color  = "red"),
      cell_text(color  = 'white', weight = "bold")),
    locations = cells_body(
      columns = AGE,
      rows = AGE >= 65))


# Here, we apply the styles to cells where SUBJID == "075"
adsl |>
  gt() |>
  tab_header(title = "ADSL Listing") |>
  tab_footnote(footnote = "Confidential") |>
  tab_style(
    style = list(
      cell_fill(color  = "red"),
      cell_text(color  = 'white', weight = "bold")),
    locations = cells_body(
      columns = everything(),
      rows = SUBJID == "075"))



# Another Method ----------------------------------------------------------
# Another method for adding color elements to a gt table is using data_color,
# which will apply some automatic rules to determine a color scale to use in the
# table


# We can apply a color scheme to numeric variables in the table using the
# method = "numeric" argument ranging from yellow for lower values and blue
# for larger values
adsl |>
  gt() |>
  data_color(
    method = "numeric",
    palette = c("#ffffbf", "#91bfdb"))


# Here we can use the AGE column to specify the coloring scheme but to also
# to apply to all other columns
adsl |>
  gt() |>
  data_color(
    columns = AGE,
    palette = c("#ffffbf", "#91bfdb"),
    target_columns = everything())


# Instead of specifying colors we can specify a pre-existing palette definition
# such as inferno
adsl |>
  gt() |>
  data_color(
    columns = AGE,
    palette = "inferno",
    target_columns = everything())


adsl |>
  gt() |>
  data_color(
    columns = AGE,
    palette = "plasma",
    target_columns = everything())

help(data_color)    



# Documentation -----------------------------------------------------------

# Help Pages
help("tab_style",       "gt")
help("cell_fill",       "gt")
help("cell_text",       "gt")
help("data_color",      "gt")
help("cells_body",      "gt")
help("cells_title",     "gt")
help("cell_borders",    "gt")
help("cells_footnotes", "gt")

# Website References
# https://gt.rstudio.com/articles/gt.html

# -------------------------------------------------------------------------
