
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Pipelines - Sequential Scripts

# Pseudo Code -------------------------------------------------------------

# |- set up
# |- Prepare data for analysis
#  |- Create table using prepared data
#  |- Summarize the prepared data
#    |- Create plot based on summarized data
# |- Run linear model on the prepared data
# |- Save model results

# Setup -------------------------------------------------------------------

library(tidyverse)
library(janitor)
library(broom)

filepath_base <- "R/"


# Run the Jobs ------------------------------------------------------------

# source() runs an entire script in the background
# file.path() is a shortcut to append paths {ie. paste(x, y, sep = "/")}

source(file.path(filepath_base, "Seq 1 - Get Raw Data.R"))
source(file.path(filepath_base, "Seq 2 - Prepare Data.R"))
source(file.path(filepath_base, "Seq 3 - Summarize Data.R"))
source(file.path(filepath_base, "Seq 4 - Analyze Data.R"))
source(file.path(filepath_base, "Seq 5 - Analysis Results.R"))
source(file.path(filepath_base, "Seq 6 - Create Plot.R"))
source(file.path(filepath_base, "Seq 7 - Create Table.R"))


# Sequential Scripts ------------------------------------------------------

# -- Pros --
# This helps us break down the larger script into smaller ones
# Makes it easier to track the results of each step
# Can automatically run all scripts at once, or one step at a time


# -- Cons --
# But as the pipeline and procedures get more complex:
# - it will be hard to make adjustments
# - it will be hard to pick up in the middle of a pipeline

# -------------------------------------------------------------------------
