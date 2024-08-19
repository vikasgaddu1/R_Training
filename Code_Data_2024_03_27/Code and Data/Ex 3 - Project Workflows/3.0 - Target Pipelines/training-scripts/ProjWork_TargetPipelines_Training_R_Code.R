
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Pipelines - Using Targets

# Packages & Functions on Display:
# - {targets 0.4.2}:  tar_script, tar_option_set, tar_target, tar_edit, tar_make,
#                    tar_exist_script, tar_validate, tar_manifest, tar_glimpse,
#                    tar_visnetwork, tar_progress_summary, tar_meta, tar_read,
#                    tar_load, tar_delete, tar_destroy, tar_outdated



# Pseudo Code -------------------------------------------------------------

# |- Get raw data
# |- Prepare data for analysis
#  |- Create table using prepared data
#  |- Summarize the prepared data
#    |- Create plot based on summarized data
# |- Run linear model on the prepared data
# |- Save model results



# Pseudo Code: Target Pipeline --------------------------------------------
# Demonstration: Do not run this code chunk

# Load Pipeline Packages
library(targets)
library(tidyverse)
library(janitor)
library(broom)


# Load Custom Pipeline Functions
source("R/pipeline_fns.R")


# Simulate the Functions
path_to_rawdata <- "data/diamond_data.rds"

fn_write_data(diamonds, output_path = path_to_rawdata)

df_raw        <- fn_get_data(path_to_rawdata)
df_prepared   <- fn_prepare_data(df_raw)
df_analysis   <- fn_analyze_data(df_prepared)
summary_data  <- fn_summary_data(df_prepared)
summary_table <- fn_create_table(df_prepared)
summary_plot  <- fn_create_plot(summary_data)
model_aov     <- fn_analyze_data(df_prepared)
model_table   <- fn_model_summary(model_aov)



# Target Pipeline ---------------------------------------------------------


## Pre-Pipeline Operations ----
# Imagine we are using data stored in a data directory
path_to_rawdata <- "data/diamond_data.rds"
fn_write_data(diamonds, output_path = path_to_rawdata)



## Define the Pipeline ----
targets::tar_script(      # Create '_targets.R' file in project/working directory
  ask = FALSE,            # Set 'ask' to TRUE to confirm overwrite of existing file
  code = {                # Use {...} to wrap many operations in the pipeline


    # -- Load Packages & Personal Functions --
    # These are the packages and functions that will be required in the pipeline
    tar_option_set(packages = c("dplyr", "ggplot2", "stringr", "readr",
                                "janitor", "broom", "tibble"))
    source("R/pipeline_fns.R")


    # -- Create a Pipeline Definition with `list()` --
    # Use a list() to hold the`tar_target()` pipeline steps
    # 'Name' gives the target an informative name so we know what the process is doing
    # 'Command' is the R code we want to run at this step
    # 'Format' means that the pipeline will monitor this file for changes
    list(


      # Specifying format = "file" can monitor any type of file for changes
      tar_target(
        name    = monitor_this_file,
        command = "data/diamond_data.rds",
        format  = "file"),


      # The 'command' argument accepts any amount of R code
      tar_target(
        name    = step_1_getdata,
        command = monitor_this_file %>% read_rds()),


      # But using custom functions will make it easier to debug the pipeline
      tar_target(
        name    = step_2_preparedata,
        command = fn_prepare_data(step_1_getdata)),


      tar_target(
        name    = step_3_analyzedata,
        command = fn_analyze_data(step_2_preparedata)),


      # No need to keep track of sequence order, 'targets' will track it for us
      # Notice the following steps are not in sequential order:
      # 'plot_summary' depends on 'data_summary' but 'data_summary' is listed last
      tar_target(name = plot_summary,  fn_create_plot(data_summary)),
      tar_target(name = table_summary, fn_create_table(step_2_preparedata)),
      tar_target(name = model_summary, fn_model_summary(step_3_analyzedata)),
      tar_target(name = data_summary,  fn_summary_data(step_2_preparedata))
    )
  })



# Working with the Pipeline -----------------------------------------------

targets::tar_exist_script()            # Check to see if _targets.R exists
targets::tar_edit()                    # Open _targets.R file for manual editing
targets::tar_validate()                # Check pipeline definition for errors

targets::tar_manifest()                # See Pipeline in Table Format
targets::tar_glimpse()                 # See Pipeline Dependency Graph
targets::tar_visnetwork()              # See Pipeline Dependency Graph with Status


# Run the Pipeline ---
targets::tar_make()
targets::tar_progress_summary()        # See progress of the pipeline
targets::tar_visnetwork()              # See the resulting graph



# Pipeline Metadata -------------------------------------------------------

# Check "_targets" directory for metadata and temporary objects


targets::tar_meta()                                  # View all pipeline metadata
targets::tar_meta(fields = "seconds")                # View subsets of metadata
targets::tar_meta(fields = c("error", "warnings"))   # Including run time, errors, etc.


targets::tar_read("plot_summary")                    # View individual pipeline results
targets::tar_read("step_1_getdata")
targets::tar_read("monitor_this_file")


targets::tar_load("step_1_getdata")                  # Load target into RStudio Environment
print(step_1_getdata)


# Remove the Pipeline ---
targets::tar_delete()                  # Delete cache results in _targets/objects/
targets::tar_destroy()                 # Remove the entire pipeline for a fresh start


# Making Changes to the Pipeline ------------------------------------------
# Make edits to any of the functions or data, and see what portions are out of date
# - Note: minor changes to scripts like white space and comments are not tracked

# Make a change to the Data
diamonds %>%
  slice_sample(prop = 0.10) %>%
  write_rds("data/diamond_data.rds")


# Now see what is outdated
targets::tar_glimpse()        # tar_glimpse() doesn't tell us what is out of data
targets::tar_visnetwork()     # tar_visnetwork() does
targets::tar_outdated()       # See what is outdated in vector format


# Re-make the pipeline
targets::tar_make()


# Documentation -----------------------------------------------------------

# Vignette
vignette("overview", package = "targets")

# Website
# https://docs.ropensci.org/targets/

# Online Book
# https://books.ropensci.org/targets/


# Additional Notes --------------------------------------------------------

# - Static code analysis scans scripts and matches patterns in functions and arguments
# - Functions should do one of three things: Process, Analyze, Summarize
# - Functions should not call 'source()', 'setwd()', or 'data()' because targets takes care of all that
# - Targets should be large enough to save time when skipped, but small enough to allow for them to be skipped
# - Pointer information will not be saved, like database connections
# - Ignores trivial changes like comments and white space

# -------------------------------------------------------------------------
