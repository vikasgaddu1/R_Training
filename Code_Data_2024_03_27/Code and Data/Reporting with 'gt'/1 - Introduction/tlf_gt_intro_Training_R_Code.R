
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2024 Anova Groups All rights reserved

# Course: Clinical Tables with 'gt'
# Lesson: Introduction

# Packages & Functions on Display:
# - {gt 0.10.1}: gt_preview, gt, opt_interactive


# Concepts ----------------------------------------------------------------
# In this lesson, we will introduce the course on the gt package. In the gt
# course, we will learn the features and functionality of the gt package and how
# to create clinical tables & listings and how to include figures using it. The
# gt package is designed for creating display tables. A display table for the
# purpose of this course is for output only. In contrast to a data table which
# is designed to hold data that can be input into another process.

# There are several packages in R that are designed to create display tables,
# but in this course, we will just focus on the gt package.

# The lessons in this course will be presented using some sample ADaM data
# frames that are available once you install the most recent version of the gt
# package.

# In this introduction lesson, we will cover the following functions in the gt
# package: gt(), gt_preview(), opt_interactive(). Then in subsequent lessons we
# will cover additional functions that will allow us to format the gt display
# table to have the desired look and feel


# Setup -------------------------------------------------------------------

# Load Packages
library(tidyverse)
library(gt)

# Data rx_adsl is a sample ADaM data frame that is included in the gt package.
# Let's filter it down to just a few variables and rows and save it as a data
# frame called adsl
adsl <-
  rx_adsl |>
  select(USUBJID, TRTA, SEX, AGE, BLBMI) |>
  filter(AGE < 35)

adsl


# Getting Started ---------------------------------------------------------

# First we will view results in the viewer using the gt_preview() function. The
# gt_preview() function is helpful when you want to see a small portion of your
# input data.
adsl |> gt_preview()

# Now we will demonstrate using some gt_preview parameter options. The top_n
# top_n and bottom_n parameters allow you to specify how many of the first and
# last rows you would like to preview.
adsl |>
  gt_preview(
    top_n        = 2,
    bottom_n     = 2,
    incl_rownums = FALSE)


# Now, we will work with the gt() function. The gt() function creates a gt table
# object. Using this function is the first step in a typical gt workflow. Once
# we have the gt table object, we can perform styling transformations before
# rendering to a display table of various formats.
adsl |> gt()


# By default a gt table is rendered as static HTML. The opt_interactive()
# function allows us to change the static HTML into interactive HTML. Below we
# show and example of turning on table searching, row filtering, row highlights
# on hover, text wrapping, and page size selection.

rx_adsl |>
  gt() |>
  opt_interactive(
    use_search           = TRUE,
    use_filters          = TRUE,
    use_resizers         = TRUE,
    use_highlight        = TRUE,
    use_text_wrapping    = TRUE,
    use_page_size_select = TRUE)



# Documentation -----------------------------------------------------------

# Help Pages
help("gt",              "gt")
help("gt_preview",      "gt")
help("opt_interactive", "gt")


# Website References
# https://gt.rstudio.com/articles/gt.html

# -------------------------------------------------------------------------
