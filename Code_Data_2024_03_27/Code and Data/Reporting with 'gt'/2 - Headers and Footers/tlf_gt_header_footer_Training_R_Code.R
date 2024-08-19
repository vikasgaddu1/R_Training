
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2024 Anova Groups All rights reserved

# Course: Clinical Tables with 'gt'
# Lesson: Headers and Footers

# Packages & Functions on Display:
# - {gt 0.10.1}: tab_header, tab_footer, opt_align_table_header,
#               opt_footnote_marks


# Concepts ----------------------------------------------------------------

# In this lesson, we will be examining methods for adding headers and
# and footnotes to a report.

# Setup -------------------------------------------------------------------

# Load Packages
library(tidyverse)
library(gt)


# Data - rx_adsl is a sample ADaM data frame that is included in the gt package.
# Let's filter it down to just a few variables and rows and save it as a data
# frame called adsl.
adsl <-
  rx_adsl |>
  select(USUBJID, TRTA, SEX, AGE, BLBMI) |>
  filter(AGE < 35)


# Table Headers -----------------------------------------------------------

# Titles and sub-titles can be added to a report using the tab_header()
# function. There is a title and a subtitle argument to assign values to
# a title and a subtitle respectively.

adsl |>
  gt() |>
  tab_header(
    title    = "ADSL Listing",
    subtitle = "Study: GT")


## Text Styling ------------------------------------------------------------
# If we use the md() function (md stands for markdown) we can add markdown and
# html tags in our titles and subtitles. The example below shows how to create
# multiple titles and/or subtitles using the double space at the end of a title
# and <br> html tag.
#
# - The first title uses the ** ** for bold and ends in two spaces for the line
#  break.
# - The first subtitle uses the * * for italics
#
# For code readability, it is recommended to use the <br> rather than two spaces
# at the end of a title or subtitle.

adsl |>
  gt() |>
  tab_header(
    title = md("**ADSL Listing**  
                Study GT<br>
                Another Title!"),
    subtitle = md("*a subtitle*<br>
                  Another subtitle
                  Even Another subtitle"))


## Text Alignment ----------------------------------------------------------
# We can use the opt_align_header() function to align titles and subtitles left,
# center, or right.

adsl |>
  gt() |>
  tab_header(
    title = md("ADSL Listing<br>
                Study GT<br>
                Another Title!"),
    subtitle = md("a subtitle<br>
                  Another subtitle")) |>
  opt_align_table_header(align = c("left"))


# Footers -----------------------------------------------------------------
# To add footnotes, use the tab_footnote() function. If the footnote needs to
# reference something in the table, the locations parameter can be specified.
# Here the footnote is referring to a column label.

adsl |>
  gt() |>
  tab_header(
    title = md("ADSL Listing<br>
                Study GT<br>
                Another Title!"),
    subtitle = md("a subtitle<br>
                  Another subtitle")) |>
  opt_align_table_header(align = c("left")) |>
  tab_footnote(
    footnote = "First Footnote") |>
  tab_footnote(
    footnote = "Second Footnote",
    locations = cells_column_labels(columns = AGE))



## References --------------------------------------------------------------
# Footnotes can also refer to cell values. The third footnote we added
# refers to the subject(s) with the lowest age.

adsl |>
  gt() |>
  tab_header(
    title = md("ADSL Listing<br>
                Study GT<br>
                Another Title!"),
    subtitle = md("a subtitle<br>
                   Another subtitle")) |>
  opt_align_table_header(align = c("left")) |>
  tab_footnote(
    footnote = "First Footnote") |>
  tab_footnote(
    footnote = "Second Footnote",
    locations = cells_column_labels(columns = AGE)) |>
  tab_footnote(
    footnote = "Youngest subject",
    locations = cells_body(
      columns = AGE,
      rows = AGE == min(AGE)))


# The footnote symbols can be customized using the opt_footnote_marks()
# function.
adsl |>
  gt() |>
  tab_header(
    title = md("ADSL Listing<br>
                Study GT<br>
                Another Title!"),
    subtitle = md("a subtitle<br>
                   Another subtitle")) |>
  opt_align_table_header(align = c("left")) |>
  tab_footnote(
    footnote = "First Footnote") |>
  tab_footnote(
    footnote = "Second Footnote",
    locations = cells_column_labels(columns = AGE)) |>
  tab_footnote(
    footnote = "Youngest subject",
    locations = cells_body(
      columns = AGE,
      rows = AGE == min(AGE))) |>
  opt_footnote_marks(marks = c("*", "!"))



# Documentation -----------------------------------------------------------

# Help Pages
help("tab_header",             "gt")
help("tab_footnote",           "gt")
help("opt_footnote_marks",     "gt")
help("opt_align_table_header", "gt")


# Website References
# https://gt.rstudio.com/articles/gt.html

# -------------------------------------------------------------------------
