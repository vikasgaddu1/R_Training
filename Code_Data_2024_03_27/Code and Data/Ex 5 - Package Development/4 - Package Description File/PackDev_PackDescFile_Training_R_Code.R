
# Anova Accel2R - Clinical R Training -----------------------------------
# © 2021 Anova Groups All rights reserved

# Title: The Package Description File

# Packages & Functions on Display:
# - {devtools 2.4.2}
# - {usethis  2.0.1}: use_news_md, use_version, use_cc0_license, use_pipe, use_package


# Setup -------------------------------------------------------------------
# Devtools is a meta-package that includes dozens of packages meant for assisting
# with common workflows in R and RStudio, including working projects and packages

library(devtools)


# Description File --------------------------------------------------------
# This is the file that provides both the basic information about your package,
# but it also defines the other package dependencies that you will want to use
# within your own functions


# Title       : One line description of the package (<= 65 characters)
# Description : One paragraph giving a more detailed description of the package (limited to 80 characters per line)
# Authors@R   : the person() function helps you define the package authors and maintainers with relevant contact information
#              every package must have at least one author, and at least one maintainer, with an email address
# URL         : Generally a website where the users can go for more information regarding the pkg or author
# BugReports  : A URL where users can submit issues with the packages
# License     : Describes who can use your package. This is only necessary if making pkg public
# Imports     : lists the external packages that your package functions need to work
# Suggests    : lists the external packages that are not required by your functions, but having them
#              offers additional functionality
# Version     : At least two integers (0.10, 1.0.0, 3.2.1)
#              Recommended version format [major].[minor].[patch]



# Package Version ---------------------------------------------------------
# Updating package versions is a manual process, and entirely up to you
# as to what you include in major, minor, or patch-related updates. It is
# recommended to use the syntax [major].[minor].[patch] for version numbers


use_news_md()   # Create a NEWS file to list the change log, update manually
use_version()   # Automatically increment the version

use_version("major")
use_version("minor")
use_version("patch")


# Then, open DESCRIPTION file to see the version change
# And, open the NEWS file to add the highlighted changes in that version



# Package Licenses --------------------------------------------------------
# - A license file will inform other users of how they can use your package
# - Most common R package licenses are CC0, MIT, and GPL3
# - If your package uses code you didn't write, you must ensure you're able
#  to re-package it under its given license


use_cc0_license()  # Can be used by anyone for any purpose
use_mit_license()  # Can use and redistribute package, as long as it remains under a MIT license
use_gpl3_license() # Can use and redistribute package, as long as it remains under a GPL license


# - These helper functions add the license to the DESCRIPTION file, along with
#  the associated LICENSE file to the package directory


# Learn More:
# https://tldrlegal.com/
# https://choosealicense.com/licenses/
# https://r-pkgs.org/license.html



# Package Dependencies ----------------------------------------------------
# Packages listed in 'imports'  ARE installed when a user installs your package
# Packages listed in 'suggests' ARE NOT installed when a user installs your package


# Add packages to DESCRIPTION file
use_pipe()                                     # Include the tidyverse pipe in your fns
use_package("dplyr")                           # Import dplyr
use_package("readr", min_version = "1.0.0")    # Import tidyr version 1.0.0
use_package("stringr", type = "Suggests")      # Suggest stringr for tests/documentation


# Notes:
# - You should NEVER use a library() call inside a package

# - Try to minimize your package dependencies, both for the end user and for yourself.
#  If you need to track the changes in a dozen packages to ensure a single function
#  continues to work, then that will be a headache for you down the line

# - 'suggests' can be useful for unit tests or documentation, but if you want to
#  use the suggested package, then you have to check that the package is available
#  using `requireNamespace(pkgname, quietly = TRUE)` to check the status of the
#  pkgname on the user's system

# Documentation -----------------------------------------------------------

# Help Pages
help(use_package,     package = "usethis")
help(use_mit_package, package = "usethis")
help(use_version,     package = "usethis")

# Learn More:
# https://r-pkgs.org/description.html

# Websites:
# usethis    : https://usethis.r-lib.org
# devtools   : https://devtools.r-lib.org/
# R Packages : https://r-pkgs.org

# -------------------------------------------------------------------------
