# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Controlling RStudio Startup with the R Profile

# Packages & Functions on Display:
# - {usethis 2.0.1}: edit_r_profile


# Controlling the R Profile -----------------------------------------------

library(usethis)
library(stringr)

# Modify the RStudio startup behavior for:
usethis::edit_r_profile(scope = "user")       # Currently active user
usethis::edit_r_profile(scope = "project")    # Currently active project


# Copy to R Profile -------------------------------------------------------

# Creating a Startup Message -----

cat(stringr::str_dup("-", 80), sep = "\n")    # Create a line break
cat("Starting R!", sep = "\n")                # Print a message


# Run R code in the start up
stringr::str_glue("- Printing a random number {stats::runif(n = 1)}!")


# Define base file paths to use throughout the project
filepath_base <- getwd()
stringr::str_glue("- Defining `filepath_base` at `{filepath_base}`")


# Load functions we want to use for this project
cat("- Loading custom functions", sep = "\n")
source(file.path(filepath_base, "R/pipeline_fns.R"))


# Define custom infix operators
cat("- Defining the %|% operator", sep = "\n")
`%|%` <- function(x, y) paste(x, y)


# Get System Information
Sys.info()[["user"]] %|%
  "on" %|%
  Sys.info()[["sysname"]] %|%
  Sys.info()[["version"]]


# End Startup Message
cat(stringr::str_dup("-", 80), sep = "\n")


# Loading 'renv' Environment Profile ----
# Note: it is generally not a good idea to load packages in the R Profile,
#      because when sharing a script, another user may not have access to your
#      R Profile, and will have different startup modifications

renv::activate(profile = "my_development_environment")
renv::use("dplyr@1.0.0", "tidyr")


# Restart R  --------------------------------------------------------------

# See the effects of R Profile modifications when starting a new session
rstudioapi::restartSession()

# Documentation -----------------------------------------------------------

help(edit_r_profile, package = "usethis")

# Additional Uses
# - Store API keys
# - Environment Variables

# -------------------------------------------------------------------------
