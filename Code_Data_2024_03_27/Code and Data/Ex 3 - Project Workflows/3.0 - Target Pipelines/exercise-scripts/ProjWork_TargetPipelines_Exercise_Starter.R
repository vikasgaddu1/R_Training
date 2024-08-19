
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Exercise starter

library(targets)

## Define the Pipeline ----
targets::tar_script(      # Create '_targets.R' file in project/working directory
  ask = FALSE,            # Set 'ask' to TRUE to confirm overwrite of existing file
  code = {                # Use {...} to wrap many operations in the pipeline


    # -- Load Packages & Personal Functions --
    # These are the packages and functions that will be required in the pipeline
    tar_option_set(packages = c("dplyr", "ggplot2", "janitor", "broom"))

    # source the file of functions.
    source("exercise-scripts/targpipe_functions_def.R")

    # Define some global variables.
    company  <- "Anova"
    study    <- "ABC"
    environ  <- "production"
    basepath <- "../"
    codepath <- "exercise-scripts/"
    datapath <- "data/"

    # -- Create a Pipeline Definition with `list()` --
    # Use a list() to hold the`tar_target()` pipeline steps
    # 'Name' gives the target an informative name so we know what the process is doing
    # 'Command' is the R code we want to run at this step
    # 'Format' means that the pipeline will monitor this file for changes
    list(


      # Specifying format = "file" can monitor any type of file for changes
      tar_target(
        name    = monitor_dm_file,
        command = paste0(basepath, datapath, "DM.rds"),
        format  = "file"),

      tar_target(
        name    = monitor_ae_file,
        command = paste0(basepath, datapath, "AE.rds"),
        format  = "file"),

      # The 'command' argument accepts any amount of R code
      tar_target(
        name    = get_dm_data,
        command = monitor_dm_file %>% fn_getdmdata()),

      tar_target(
        name    = get_ae_data,
        command = monitor_ae_file %>% fn_getaedata()),

      tar_target(
        name    = dataprepsumm,
        command = fn_dataprepsumm(dm = get_dm_data, ae = get_ae_data)),

      tar_target(
        name = show_data,
        command = fn_show_data(dataprepsumm))
    )
  })
