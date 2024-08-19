
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
# Create the unique ID associated with current system
# This will help you identify where the changes are coming from
# and track who is responsible for what adjustments

use_git_config(user.name = "My Username", user.email = "my_email@address.com")


# Add the necessary files to the package directory, and "commit" existing files
# to the first version control snapshot
use_git()



# RStudio + Git -----------------------------------------------------------

# Close / Terminate RStudio (Menu Session > Terminate)
# - Now you'll see a new "Git" Panel near the "Environment" Panel
# - And, you'll see a new file in package project directory called '.gitignore'


# Package Structure
# .gitignore : lists files that will NOT be tracked in version snapshots



# Using Git ---------------------------------------------------------------

# Make changes to a file, save the script. Now, see that the file has been added
# to the Git panel


# Git Vocabulary
# Diff    : Shows the differences between current file and snapshot of file
# Commit  : Opens menu to 'stage' a file, which indicates file is ready for snapshot
# Pull    : Pull snapshot from remote repository (ie. GitHub) and overwrite local files
# Push    : Push snapshot to remote repository (ie. GitHub)
# History : View history of 'commits' with messages by user, date, and time
# Revert  : Select a file to undo all changes and revert to previous snapshot version
# Ignore  : Select a file to be excluded from version snapshot (ie. add file to .gitignore)
# Shell   : Open the shell console for advanced command-line git usage
# Branch  : Create a new branch to store current file snapshot (ie. master/dev/prod)



# Commits
# Commit often, with informative messages to describe WHY changes were made.
# This creates an outline of the evolution of the file,
# and will make it easier to revert back to a specific previous version



# Git Panel Icons
# ? : File is being ignored
# A : File is staged, and is approved for inclusion in version snapshot
# D : File has been deleted from the repository
# M : File has been modified, and needs to be staged before being included in snapshot



# Final Notes -------------------------------------------------------------
# We are not covering GitHub in this course, but in order to link this existing
# package project to GitHub, the use_github() function will assist with setting
# up the remote repository

use_github()
help(use_github, package = "usethis")

# Learn More:
# https://happygitwithr.com/existing-github-last.html


# Documentation -----------------------------------------------------------

# Help Pages
help(use_git,        package = "usethis")
help(use_git_config, package = "usethis")

# Learn More:
# https://r-pkgs.org/git.html

# Websites
# usethis          : https://usethis.r-lib.org
# devtools         : https://devtools.r-lib.org/
# Happy Git with R : https://happygitwithr.com
# R Packages       : https://r-pkgs.org

# -------------------------------------------------------------------------
