
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Version Control with Git

# Packages & Functions on Display:
# - {devtools 2.4.2}
# - {usethis  2.0.1}: use_git_config, use_git


# Setup -------------------------------------------------------------------
# Devtools is a meta-package that includes dozens of packages meant for assisting
# with common workflows in R and RStudio, including working projects and packages

library(devtools)

# Configuring Git ---------------------------------------------------------
use_git_config(user.name = "My Username", user.email = "my_email@address.com")


# Add the necessary files to the package directory, and "commit" existing files
# to the first version control snapshot
use_git()

use_version("patch")
