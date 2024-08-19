
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2024 Anova Groups All rights reserved

# Course: Clinical Tables with 'gt'
# Lesson: Modifying Rows

# Packages & Functions on Display:
# - {gt 0.10.1}: gt, tab_stubhead


# Setup -------------------------------------------------------------------

# Load the packages necessary for this lesson.
library(gt)
library(tidyverse)

# Data
# rx_adsl is a sample ADaM data frame that is included in the gt package.
# Let's filter it down to just a few variables and rows and save it as
# a data frame called adsl.
adsl <-
  rx_adsl |>
  select(TRTA, SEX, AGE, BLBMI) |>
  filter(BLBMI < 35 & !is.na(TRTA))



# Row Labels --------------------------------------------------------------

# Starting point
adsl |> gt()


# Using the rowname_col argument in the gt() function, our table now has 3
# columns instead of 4. The column "TRTA" is now in the stub area of the gt
# table
adsl |> gt(rowname_col = "TRTA")


# To add a label for a variable in the stub area, we can use tab_stubhead()
adsl |>
  gt(rowname_col = "TRTA") |>
  tab_stubhead(label = "Treatment")



# Group Labels ------------------------------------------------------------

# Creating a grouping variable by rows
adsl |> gt(groupname_col = "TRTA")


# To get the groupname_col label to appear, we will need to set the
# row_group_as_column argument to TRUE in the gt() function call
adsl |>
  gt(groupname_col = "TRTA",
     row_group_as_column = TRUE) |>
  tab_stubhead(label = "Treatment")


# Creating a grouping of two variables by rows
adsl |>
  gt(groupname_col = c("TRTA", "SEX"))


# Nested Groups -----------------------------------------------------------

# If we wanted to get separate sub-tables for these groups, it doesn't work the
# way we might want it to. Creating a grouping variable by rows doesn't work
# with this syntax
adsl |>
  gt(groupname_col = c("TRTA", "SEX"),
     row_group_as_column = TRUE)


# For more than one nested row variable, we need to prepare the data exactly how
# we want it displayed.
# - Note we are setting values of row group values to blank to clean up the
#  listing.
adsl |>
  arrange(TRTA, SEX) |>
  mutate(
    SEX =
      case_when(
        lag(SEX) == SEX ~ "",
        .default = SEX),
    TRTA =
      case_when(
        lag(TRTA) == TRTA & SEX == "" ~ "",
        .default = TRTA)) |>
  gt()


# This technique will come in handy for summary tables. Note that we ungroup the
# data prior to going into the gt() function as it will alter how it presents
# the output table.
adsl |>
  arrange(TRTA, SEX) |>
  group_by(TRTA, SEX) |>
  summarize(
    AGE   = mean(AGE),
    BLBMI = mean(BLBMI)) |>
  mutate(
    TRTA =
      case_when(
        lag(TRTA) == TRTA ~ "",
        .default = TRTA)) |>
  ungroup() |>
  gt()


# As you can see this is not as clean as the previous output table that removed
# the group by attribute from the data prior to going into the gt() function.
adsl |>
  arrange(TRTA, SEX) |>
  group_by(TRTA, SEX) |>
  summarize(
    AGE   = mean(AGE),
    BLBMI = mean(BLBMI)) |>
  mutate(
    TRTA =
      case_when(
        lag(TRTA) == TRTA ~ "",
        .default = TRTA)) |>
  gt()



# Documentation -----------------------------------------------------------

# Help Pages
help("tab_stubhead", "gt")

# Website References
# https://gt.rstudio.com/articles/gt.html

# -------------------------------------------------------------------------




