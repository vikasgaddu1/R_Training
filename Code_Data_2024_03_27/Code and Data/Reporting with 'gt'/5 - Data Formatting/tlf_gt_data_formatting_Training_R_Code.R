# Anova Accel2R - Clinical R Training -----------------------------------
# © 2024 Anova Groups All rights reserved

# Course: Clinical Tables with 'gt'
# Lesson: Data Formatting

# Packages & Functions on Display:
# - {gt 0.10.1}: info_date_style, fmt_date, info_time_style, fmt_datetime,
#               fmt_integer, fmt_number, fmt_bins, sub_missing
#

# Concepts ----------------------------------------------------------------

# Load the packages necessary for this lesson.
library(gt)
library(tidyverse)


# Data
# For this lesson, we will use a data frame from the _data/ directory. Let's
# create an age bin variable and filter it down to just a few variables. We'll
# also create a datetime variable.
adsl <-
  readRDS('_data/ADSL.rds') |>
  mutate(
    estimated_days_old = AGE * 365.25,
    age_bins = cut(
      AGE,
      breaks   = c(18, 30, 50, 100),
      dig.labs = 0),
    datetime = Sys.time()) |>
  select(
    SUBJID,
    ARM,
    estimated_days_old,
    AGE,
    age_bins,
    TRTSDT,
    TRTEDT,
    datetime)



# Formatting Dates --------------------------------------------------------

# As you can see, there are a few of the variables on this report that could use
# some formatting. The gt package has over 20 functions in the fmt_() family.
# This lesson will focus on a few that we feel are relevant to clinical
# programming. We will focus on dates/times, integers, and fractional (decimal)
# values.
adsl |> gt()


# Use 'info_date_style' to list all date formatting options in gr
info_date_style()


# Let's focus on the date variables TRTSDT and TRTEDT. We can use the fmt_date()
# function to change the appearance of the date from yyyy-mm-dd to mm/dd/yy by
# choosing a date style of "yMd".
adsl |>
  gt() |>
  fmt_date(
    columns    = c(TRTSDT, TRTEDT),
    date_style = "yMd")


# Formatting Date Times ---------------------------------------------------

# Now let's look at formatting the datetime variable by using the fmt_datetime()
# function. But first let's look at the available time styles using the
# info_time_style() function.
info_time_style()


# We can use the date and time styles together in the fmt_datetime() function.
adsl |>
  gt() |>
  fmt_datetime(
    sep        = " ",
    columns    = datetime,
    date_style = "yMd",
    time_style = "h_m_s_p")



# Formatting Numbers ------------------------------------------------------

# Now let's look at formatting numbers. We have a couple of numbers in our
# dataset AGE and estimated_days_old. Let's format the variable age to display
# the patient's age with the text "years old" after it. We can format integer
# values by using the fmt_integer() function.
adsl |>
  gt() |>
  fmt_integer(
    columns = AGE,
    pattern = "{x} years old")


# We can also format numbers that have decimal places by using the fmt_number()
# function. Here we add a '~' prefix, have a suffix of 'days old'. We also
# specify to include commas in values 1,000 or more.
adsl |>
  gt() |>
  fmt_number(
    columns  = estimated_days_old,
    decimals = 1,
    sep_mark = ',',
    pattern  = "~{x} days old")



# Formatting Bins ---------------------------------------------------------

# Now let's look at formatting the age bins variable that we created.
adsl |>
  gt() |>
  fmt_bins(
    columns = age_bins,
    sep = ' to ')


# We can also create our own bins using the fmt_integer() function.
adsl |>
  gt() |>
  fmt_integer(
    rows    = AGE < 40,
    columns = AGE,
    pattern = 'younger than 40') |>
  fmt_integer(
    rows    = AGE >= 40 & AGE < 60,
    columns = AGE,
    pattern = '40 - 60') |>
  fmt_integer(
    rows    = AGE >= 60,
    columns = AGE,
    pattern = '60 or older')



# Formatting Missing Values -----------------------------------------------

# If we want to substitute the missing values in a table with another character,
# we can use the sub_missing() function. Here we substitute the missing values
# with '-.-'.
adsl |>
  gt() |>
  sub_missing(
    columns = everything(),
    missing_text = "-.-")



# Documentation -----------------------------------------------------------

# Help Pages
help("fmt_bins",        "gt")
help("fmt_date",        "gt")
help("fmt_number",      "gt")
help("fmt_integer",     "gt")
help("sub_missing",     "gt")
help("fmt_datetime",    "gt")
help("info_time_style", "gt")
help("info_date_style", "gt")

# Website References
# https://gt.rstudio.com/articles/gt.html
# -------------------------------------------------------------------------
