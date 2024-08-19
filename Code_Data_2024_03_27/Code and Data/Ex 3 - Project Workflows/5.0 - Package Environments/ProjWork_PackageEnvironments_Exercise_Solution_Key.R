
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Maintaining Package Environments

# Exercise Solution Key

# Packages & Functions on Display:
# - {renv 0.13.2}:  activate, init, dependencies, install, use, update, remove,
#                  snapshot, history, restore, upgrade, deactivate,

library(renv)
library(tibble)

# Examine dependencies as a data frame.
dep <-
  renv::dependencies() %>%
  as_tibble()

# create mydev environment.
renv::init(profile = "mydev", bare = FALSE)

# create myprod environment.
renv::init(profile = "myprod", bare = TRUE)


