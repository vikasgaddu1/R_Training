
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2024 Anova Groups All rights reserved

# Course: Clinical Tables with 'gt'
# Lesson: Headers and Footers

# Packages & Functions on Display:
# - {gt 0.10.0}: gt_preview, gt, opt_interactive


# Setup -------------------------------------------------------------------
# Load Packages

# Exercise step 1
library(tidyverse)
library(gt)

addv <-
  rx_addv |>
  select(USUBJID, TRTA, AGE, SEX, PARAMCD, AVAL) |>
  filter(PARAMCD == "PDANYM" & substr(USUBJID, 1, 5) == "GT100")


# Exercise step 2
addv |>
  gt() |>
  tab_header(title = "Listing of addv Data",
             subtitle = "At Least One Major Protocol Deviation")



# Exercise step 3
# Part a.
addv |>
  gt() |>
  tab_header(title = md("Study GT01: 4001<br>Listing of addv Data"),
             subtitle = md("At Least One Major Protocol Deviation<br>
                            For Selected Subjects"))

# Exercise step 3
# Part b.
addv |>
  gt() |>
  tab_header(title = md("<b>Study GT01: 4001</b><br>Listing of addv Data"),
             subtitle = md("**At Least One Major Protocol Deviation**<br>
                            *For Selected Subjects*"))

# Exercise step 3
# Part c.
addv |>
  gt() |>
  tab_header(title = md("<b>Study GT01: 4001</b><br>Listing of addv Data"),
             subtitle = md("**At Least One Major Protocol Deviation**<br>
                            For Selected Subjects")) |>
  opt_align_table_header(align = c("left"))

# Exercise step 3
# Part d.
addv |>
  gt() |>
  tab_header(title = md("<b>Study GT01: 4001</b><br><i>Listing of addv Data</i>"),
             subtitle = md("**At Least One Major Protocol Deviation**<br>
                            *For Selected Subjects*")) |>
  opt_align_table_header(align = c("left"))


# Exercise step 4
# Part a & b
addv |>
  gt() |>
  tab_header(title = md("<b>Study GT01: 4001</b><br><i>Listing of addv Data</i>"),
             subtitle = md("**At Least One Major Protocol Deviation**<br>
                            *For Selected Subjects*")) |>
  opt_align_table_header(align = c("left")) |>
  tab_footnote(paste("Report generated on", format(Sys.Date(), "%m/%d/%Y"))) |>
  tab_footnote("Subjects restricted to the first 9.")


# Exercise step 5
addv |>
  gt() |>
  tab_header(title = md("<b>Study GT01: 4001</b><br><i>Listing of addv Data</i>"),
             subtitle = md("**At Least One Major Protocol Deviation**<br>
                            *For Selected Subjects*")) |>
  opt_align_table_header(align = c("left")) |>
  tab_footnote(paste("Report generated on", format(Sys.Date(), "%m/%d/%Y"))) |>
  tab_footnote("Subjects restricted to the first 9.",
               locations = cells_column_labels(columns = USUBJID))


# Exercise step 6.
# Part a.
addv |>
  gt() |>
  tab_header(title = md("<b>Study GT01: 4001</b><br><i>Listing of addv Data</i>"),
             subtitle = md("**At Least One Major Protocol Deviation**<br>
                            *For Selected Subjects*")) |>
  opt_align_table_header(align = c("left")) |>
  tab_footnote(paste("Report generated on", format(Sys.Date(), "%m/%d/%Y"))) |>
  tab_footnote("Subjects restricted to the first 9.",
               locations = cells_column_labels(columns = USUBJID)) |>
  tab_footnote(footnote = "Subjects older than the average age.")

# Exercise step 6.
# Part b.
addv |>
  gt() |>
  tab_header(title = md("<b>Study GT01: 4001</b><br><i>Listing of addv Data</i>"),
             subtitle = md("**At Least One Major Protocol Deviation**<br>
                            *For Selected Subjects*")) |>
  opt_align_table_header(align = c("left")) |>
  tab_footnote(paste("Report generated on", format(Sys.Date(), "%m/%d/%Y"))) |>
  tab_footnote("Subjects restricted to the first 9.",
               locations = cells_column_labels(columns = USUBJID)) |>
  tab_footnote(
  footnote = "Subjects older than the average age.",
  locations = cells_body(
    columns = AGE,
    rows = AGE >= mean(AGE)))

# Exercise step 6.
# Part c.
addv |>
  gt() |>
  tab_header(title = md("<b>Study GT01: 4001</b><br><i>Listing of addv Data</i>"),
             subtitle = md("**At Least One Major Protocol Deviation**<br>
                            *For Selected Subjects*")) |>
  opt_align_table_header(align = c("left")) |>
  tab_footnote(paste("Report generated on", format(Sys.Date(), "%m/%d/%Y"))) |>
  tab_footnote("Subjects restricted to the first 9.",
               locations = cells_column_labels(columns = USUBJID)) |>

  tab_footnote(
    footnote = "Subjects older than the average age.",
    locations = cells_body(
      columns = AGE,
      rows = AGE >= mean(AGE))) |>
  opt_footnote_marks(marks = c("*", "!"))
