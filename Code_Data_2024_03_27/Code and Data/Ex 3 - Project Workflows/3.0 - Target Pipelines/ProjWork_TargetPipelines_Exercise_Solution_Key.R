
library(targets)

## Define the Pipeline ----
targets::tar_script(      # Create '_targets.R' file in project/working directory
  ask = FALSE,            # Set 'ask' to TRUE to confirm overwrite of existing file
  code = {                # Use {...} to wrap many operations in the pipeline


    # -- Load Packages & Personal Functions --
    # These are the packages and functions that will be required in the pipeline
    tar_option_set(packages = c("dplyr", "ggplot2", "janitor",
                                "broom"))

    source("code/targpipe_functions_def.R")

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

      # But using custom functions will make it easier to debug the pipeline
      tar_target(
        name    = dataprepsumm,
        command = fn_dataprepsumm(dm = get_dm_data, ae = get_ae_data)),

      tar_target(name = show_data,
                 command = fn_show_data(dataprepsumm)),

      tar_target(
        name = ttest_agebysex,
        command = fn_ttest_agebysex(dmdata = get_dm_data))
    )
  })


targets::tar_make()

targets::tar_manifest()                # See Pipeline in Table Format
targets::tar_glimpse()                 # See Pipeline Dependency Graph
targets::tar_visnetwork()              # See Pipeline Dependency Graph with Status

targets::tar_read("monitor_dm_file")
targets::tar_read("monitor_ae_file")
targets::tar_read("get_dm_data")                    # View individual pipeline results
targets::tar_read("get_ae_data")
targets::tar_read("show_data")
targets::tar_read("ttest_agebysex")


targets::tar_load("get_dm_data")   # Load target into RStudio Environment
print(get_dm_data)
