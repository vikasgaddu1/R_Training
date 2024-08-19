
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: Wrapping Up Package Development

# Packages & Functions on Display:
# - {devtools 2.4.2}: test, check, build, install, install_local, build_readme
# - {usethis  2.0.1}: use_readme


# Setup -------------------------------------------------------------------
# Devtools is a meta-package that includes dozens of packages meant for assisting
# with common workflows in R and RStudio, including working projects and packages

library(devtools)


# Finalizing Development --------------------------------------------------
# Once our functions, unit tests, documentation, and DESCRIPTION file are
# complete, we can finalize our package and prepare it to be shared privately or
# publicly

document() # Ensure your function documentation is up to date
test()     # Run the unit tests
check()    # Check the structure of syntax, scripts, directories
build()    # Compile source scripts and directories into a single binary file
install()  # Test the installation of the package, simulating install.packages()
library()  # Now restart/terminate RStudio, and load your package like any other


# Testing Our Package
library(mypkg)
help(fn_print_time)

# Remember, objects assigned inside a package remain static for the end user
mypkg::fn_print_time()


# Sharing Packages --------------------------------------------------------

## Privately ----
# Locate the package file (tar.gz format), and share with others
# Install packages from a local source file with install_local

install_local("path/to/mypkg.tar.gz")


## Publicly ----
# Websites like GitHub, GitLab, BitBucket offer to store your files and track
# version history.  When using one of these sites, consider using a package
# readme file to act as a landing page to welcome new users to your package.
# - See Example: https://github.com/tidyverse/dplyr#readme

use_readme_rmd()
build_readme()



# Submitting to CRAN ------------------------------------------------------
# Only a handful of volunteers thoroughly review a submission before it is
# published and made available in the official CRAN repository.  It will take
# time, going back and forth with the reviewer before a package is approved.



# CRAN Guidelines
# - Ensure valid maintainer/author email address in DESCRIPTION file
# - Ensure valid copyright and copyright holders in DESCRIPTION file
# - Do your best to ensure packages run on multiple operating systems and versions
# - Limit package updates to a new version once every 1-2 months
# - Don't disrupt the users' environment:
#  - Don't write files to local directories
#  - Don't change system options
#  - Don't install packages not listed in DESCRIPTION file
#  - Don't quit R / R Studio
#  - Don't send information over the internet
#  - Don't open external software without explicit permission



# Learn More:
# CRAN Submission Policies : https://cran.r-project.org/web/packages/policies.html
# CRAN Submission Form     : https://cran.r-project.org/submit.html
# Book - R Packages Guide  : https://r-pkgs.org/release.html


# Documentation -----------------------------------------------------------

# Package Development Cheatsheet
# https://github.com/rstudio/cheatsheets/raw/master/package-development.pdf


# Websites:
# covr       : https://covr.r-lib.org
# testthat   : https://testthat.r-lib.org
# usethis    : https://usethis.r-lib.org
# devtools   : https://devtools.r-lib.org/
# R Packages : https://r-pkgs.org/


# Package Development Keyboard Shortcuts
# Description 	          Windows & Linux 	Mac
# Build and Reload 	      Ctrl+Shift+B 	    Cmd+Shift+B
# Load All (devtools) 	  Ctrl+Shift+L 	    Cmd+Shift+L
# Test Package (Desktop) 	Ctrl+Shift+T 	    Cmd+Shift+T
# Test Package (Web) 	    Ctrl+Alt+F7 	    Cmd+Option+F7
# Check Package 	        Ctrl+Shift+E 	    Cmd+Shift+E
# Document Package 	      Ctrl+Shift+D 	    Cmd+Shift+D

# -------------------------------------------------------------------------
