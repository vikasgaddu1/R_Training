
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Maintaining Package Environments

# Packages & Functions on Display:
# - {renv 0.13.2}:  activate, init, dependencies, install, use, update, remove,
#                  snapshot, history, restore, upgrade, deactivate,


# Setup -------------------------------------------------------------------

# Why use a "Reproducible Environment"?
# - Package collection is isolated, portable, and reproducible
# - Package metadata stored in 'renv.lock' file
# - The 'renv.lock' can be copied to other computers and use renv::restore() to get same packages
# - Existing packages are copied, not downloaded, into local environment

library(renv)


# Initialize the Environment Repository -----------------------------------
# Create an environment profile using init()
# bare = TRUE  : creates an empty environment, where you have complete control
# bare = FALSE : scans all scripts in the current project, imports all pkgs in library() calls

renv::init(profile = "my_env_production",  bare = TRUE)


# Automatically Create an Environment
renv::dependencies()                        # View all packages used in current project
renv::init(profile = "my_env_development")  # Create environment by copying all active pkgs


# ---
# Note, when using multiple environment profiles in a single project
# 'renv' will ask how you to handle multiple 'private libraries'
# Select "2: Re-initialize the project with a new library." to add additional profiles
# ---


# Switch Environment Profile ----------------------------------------------
# Activating a profile will ensure the project automatically loads this profile
# when RStudio starts up

renv::activate(profile = "my_env_production")
renv::activate(profile = "my_env_development")


# Useful Functions
renv::activate(profile = NULL)     # Revert to default package environment
renv::deactivate()                 # Tell RStudio to NOT load an environment at start up


# Controlling Package Versions --------------------------------------------
# Note, install.packages() will not add packages to the 'renv' repository

renv::install(packages = c("tidyr", "dplyr"))        # Add pkgs to active profile
renv::install(packages = c("tidyr", "dplyr@1.0.0"))  # Syntax to specify pkg version


# Using Packages ----------------------------------------------------------
# When working within a 'renv' repository profile, library() will work,
# but use() ensures the version you're expecting is the one you're using

library(dplyr)
renv::use("dplyr@1.0.0", "tidyr")


# Managing the Environment ------------------------------------------------
# Note: Creating an environment snapshot will create a 'lock.file' that can
# be transferred to other users and systems, so the environment will recreated

renv::snapshot()                        # Save a snapshot of the current 'renv' profile


renv::update()                          # Update all packages in the local environment
renv::update(packages = c("dplyr"))     # Update specific packages in the local environment
renv::remove(packages = c("dplyr"))     # Remove specific packages from local environment


# Tracking the changes to your environment over time will require git
renv::history()                         # See history of all environment snapshots
renv::restore()                         # Restore a previous environment snapshot


# Environment Administration ----------------------------------------------

renv::upgrade(version = "0.13.2")       # Upgrade 'renv' package and environment definitions
renv::diagnostics()                     # View details of current environment profile


# See environment directories
renv::paths$library()
renv::paths$lockfile()


# Docker can help to ensure and local environments are usable on any OS
vignette("docker", package = "renv")


# Documentation -----------------------------------------------------------

# Website
# https://rstudio.github.io/renv/

# Vignettes
vignette("renv",     package = "renv")  # Introduction to 'renv'
vignette("lockfile", package = "renv")  # How the 'lockfile' works
vignette("profiles", package = "renv")  # How to use 'profiles'
vignette("use",      package = "renv")  # How to use 'use()'

# -------------------------------------------------------------------------
